/*
 * Copyright (c) 2003 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * @file
 * libavformat API example.
 *
 * Output a media file in any supported libavformat format. The default
 * codecs are used.
 * @example muxing.c
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

extern "C" {
#include <libavutil/avassert.h>
#include <libavutil/channel_layout.h>
#include <libavutil/opt.h>
#include <libavutil/mathematics.h>
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>
}

#include "jni_nclude/encode_video_c.h"
#include <libyuv/libyuv.h>
#include <libyuv/row.h>
#include <algorithm>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#define STREAM_FRAME_RATE 25 /* 25 images/s */
#define STREAM_PIX_FMT    AV_PIX_FMT_YUV420P /* default pix_fmt */

#define SCALE_FLAGS SWS_POINT


static VideoCreator *vc;
// a wrapper around a single output AVStream


static void log_packet(const AVFormatContext *fmt_ctx, const AVPacket *pkt) {
    AVRational *time_base = &fmt_ctx->streams[pkt->stream_index]->time_base;

    printf("pts:%s pts_time:%s dts:%s dts_time:%s duration:%s duration_time:%s stream_index:%d\n",
           av_ts2str(pkt->pts), av_ts2timestr(pkt->pts, time_base),
           av_ts2str(pkt->dts), av_ts2timestr(pkt->dts, time_base),
           av_ts2str(pkt->duration), av_ts2timestr(pkt->duration, time_base),
           pkt->stream_index);
}

static int
write_frame(AVFormatContext *fmt_ctx, const AVRational *time_base, AVStream *st, AVPacket *pkt) {
    /* rescale output packet timestamp values from codec to stream timebase */
    av_packet_rescale_ts(pkt, *time_base, st->time_base);
    pkt->stream_index = st->index;

    /* Write the compressed frame to the media file. */
    log_packet(fmt_ctx, pkt);
    return av_interleaved_write_frame(fmt_ctx, pkt);
}

/* Add an output stream. */
static void add_stream(OutputStream *ost, AVFormatContext *oc,
                       AVCodec **codec,
                       enum AVCodecID codec_id) {
    AVCodecContext *c;
    int i;
    const char *name = avcodec_get_name(codec_id);

    /* find the encoder */
    *codec = avcodec_find_encoder(codec_id);
    if (!(*codec)) {
        fprintf(stderr, "Could not find encoder for '%s'\n",
                avcodec_get_name(codec_id));
        exit(1);
    }

    ost->st = avformat_new_stream(oc, NULL);
    if (!ost->st) {
        fprintf(stderr, "Could not allocate stream\n");
        exit(1);
    }
    ost->st->id = oc->nb_streams - 1;
    c = avcodec_alloc_context3(*codec);
    if (!c) {
        fprintf(stderr, "Could not alloc an encoding context\n");
        exit(1);
    }
    ost->enc = c;

    switch ((*codec)->type) {
        case AVMEDIA_TYPE_AUDIO:
            c->sample_fmt = (*codec)->sample_fmts ?
                            (*codec)->sample_fmts[0] : AV_SAMPLE_FMT_FLTP;
            c->bit_rate = 64000;
            c->sample_rate = 44100;
            if ((*codec)->supported_samplerates) {
                c->sample_rate = (*codec)->supported_samplerates[0];
                for (i = 0; (*codec)->supported_samplerates[i]; i++) {
                    if ((*codec)->supported_samplerates[i] == 44100)
                        c->sample_rate = 44100;
                }
            }
            c->channels = av_get_channel_layout_nb_channels(c->channel_layout);
            c->channel_layout = AV_CH_LAYOUT_STEREO;
            if ((*codec)->channel_layouts) {
                c->channel_layout = (*codec)->channel_layouts[0];
                for (i = 0; (*codec)->channel_layouts[i]; i++) {
                    if ((*codec)->channel_layouts[i] == AV_CH_LAYOUT_STEREO)
                        c->channel_layout = AV_CH_LAYOUT_STEREO;
                }
            }
            c->channels = av_get_channel_layout_nb_channels(c->channel_layout);
            ost->st->time_base = (AVRational) {1, c->sample_rate};
            break;

        case AVMEDIA_TYPE_VIDEO:
            c->codec_id = codec_id;

            c->bit_rate = 400000;
            /* Resolution must be a multiple of two. */
            c->width = 640;
            c->height = 640;
            /* timebase: This is the fundamental unit of time (in seconds) in terms
             * of which frame timestamps are represented. For fixed-fps content,
             * timebase should be 1/framerate and timestamp increments should be
             * identical to 1. */
            ost->st->time_base = (AVRational) {1, STREAM_FRAME_RATE};
            c->time_base = ost->st->time_base;


            c->gop_size = 12; /* emit one intra frame every twelve frames at most */
            c->pix_fmt = STREAM_PIX_FMT;
            if (c->codec_id == AV_CODEC_ID_MPEG2VIDEO) {
                /* just for testing, we also add B-frames */
                c->max_b_frames = 2;
            }
            if (c->codec_id == AV_CODEC_ID_MPEG1VIDEO) {
                /* Needed to avoid using macroblocks in which some coeffs overflow.
                 * This does not happen with normal video, it just happens here as
                 * the motion of the chroma plane does not match the luma plane. */
                c->mb_decision = 2;
            }
            break;

        default:
            break;
    }

    /* Some formats want stream headers to be separate. */
    if (oc->oformat->flags & AVFMT_GLOBALHEADER)
        c->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
}

/**************************************************************/
/* audio output */

static AVFrame *alloc_audio_frame(enum AVSampleFormat sample_fmt,
                                  uint64_t channel_layout,
                                  int sample_rate, int nb_samples) {
    AVFrame *frame = av_frame_alloc();
    int ret;

    if (!frame) {
        fprintf(stderr, "Error allocating an audio frame\n");
        exit(1);
    }

    frame->format = sample_fmt;
    frame->channel_layout = channel_layout;
    frame->sample_rate = sample_rate;
    frame->nb_samples = nb_samples;

    if (nb_samples) {
        ret = av_frame_get_buffer(frame, 0);
        if (ret < 0) {
            fprintf(stderr, "Error allocating an audio buffer\n");
            exit(1);
        }
    }

    return frame;
}

static void
open_audio(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg) {
    AVCodecContext *c;
    int nb_samples;
    int ret;
    AVDictionary *opt = NULL;

    c = ost->enc;

    /* open it */
    av_dict_copy(&opt, opt_arg, 0);
    ret = avcodec_open2(c, codec, &opt);
    av_dict_free(&opt);
    if (ret < 0) {
        fprintf(stderr, "Could not open audio codec: %s\n", av_err2str(ret));
        exit(1);
    }

    /* init signal generator */
    ost->t = 0;
    ost->tincr = 2 * M_PI * 110.0 / c->sample_rate;
    /* increment frequency by 110 Hz per second */
    ost->tincr2 = 2 * M_PI * 110.0 / c->sample_rate / c->sample_rate;

    if (c->codec->capabilities & AV_CODEC_CAP_VARIABLE_FRAME_SIZE)
        nb_samples = 10000;
    else
        nb_samples = c->frame_size;

    ost->frame = alloc_audio_frame(c->sample_fmt, c->channel_layout,
                                   c->sample_rate, nb_samples);
    ost->tmp_frame = alloc_audio_frame(AV_SAMPLE_FMT_S16, c->channel_layout,
                                       c->sample_rate, nb_samples);

    /* copy the stream parameters to the muxer */
    ret = avcodec_parameters_from_context(ost->st->codecpar, c);
    if (ret < 0) {
        fprintf(stderr, "Could not copy the stream parameters\n");
        exit(1);
    }

    /* create resampler context */
    ost->swr_ctx = swr_alloc();
    if (!ost->swr_ctx) {
        fprintf(stderr, "Could not allocate resampler context\n");
        exit(1);
    }

    /* set options */
    av_opt_set_int(ost->swr_ctx, "in_channel_count", c->channels, 0);
    av_opt_set_int(ost->swr_ctx, "in_sample_rate", c->sample_rate, 0);
    av_opt_set_sample_fmt(ost->swr_ctx, "in_sample_fmt", AV_SAMPLE_FMT_S16, 0);
    av_opt_set_int(ost->swr_ctx, "out_channel_count", c->channels, 0);
    av_opt_set_int(ost->swr_ctx, "out_sample_rate", c->sample_rate, 0);
    av_opt_set_sample_fmt(ost->swr_ctx, "out_sample_fmt", c->sample_fmt, 0);

    /* initialize the resampling context */
    if ((ret = swr_init(ost->swr_ctx)) < 0) {
        fprintf(stderr, "Failed to initialize the resampling context\n");
        exit(1);
    }
}

/* Prepare a 16 bit dummy audio frame of 'frame_size' samples and
 * 'nb_channels' channels. */
static AVFrame *get_audio_frame(OutputStream *ost) {
    AVFrame *frame = ost->tmp_frame;
    int j, i, v;
    int16_t *q = (int16_t *) frame->data[0];

    /* check if we want to generate more frames */
    if (av_compare_ts(ost->next_pts, ost->enc->time_base,
                      vc->totalTime, (AVRational) {1, 1}) >= 0)
        return NULL;

    for (j = 0; j < frame->nb_samples; j++) {
        v = (int) (sin(ost->t) * 10000);
        for (i = 0; i < ost->enc->channels; i++)
            *q++ = v;
        ost->t += ost->tincr;
        ost->tincr += ost->tincr2;
    }

    frame->pts = ost->next_pts;
    ost->next_pts += frame->nb_samples;

    return frame;
}

/*
 * encode one audio frame and send it to the muxer
 * return 1 when encoding is finished, 0 otherwise
 */
static int write_audio_frame(AVFormatContext *oc, OutputStream *ost) {
    AVCodecContext *c;
    AVPacket pkt = {0}; // data and size must be 0;
    AVFrame *frame;
    int ret;
    int got_packet;
    int dst_nb_samples;

    av_init_packet(&pkt);
    c = ost->enc;

    frame = get_audio_frame(ost);

    if (frame) {
        /* convert samples from native format to destination codec format, using the resampler */
        /* compute destination number of samples */
        dst_nb_samples = av_rescale_rnd(
                swr_get_delay(ost->swr_ctx, c->sample_rate) + frame->nb_samples,
                c->sample_rate, c->sample_rate, AV_ROUND_UP);
        av_assert0(dst_nb_samples == frame->nb_samples);

        /* when we pass a frame to the encoder, it may keep a reference to it
         * internally;
         * make sure we do not overwrite it here
         */
        ret = av_frame_make_writable(ost->frame);
        if (ret < 0)
            exit(1);

        /* convert to destination format */
        ret = swr_convert(ost->swr_ctx,
                          ost->frame->data, dst_nb_samples,
                          (const uint8_t **) frame->data, frame->nb_samples);
        if (ret < 0) {
            fprintf(stderr, "Error while converting\n");
            exit(1);
        }
        frame = ost->frame;

        frame->pts = av_rescale_q(ost->samples_count, (AVRational) {1, c->sample_rate},
                                  c->time_base);
        ost->samples_count += dst_nb_samples;
    }

    ret = avcodec_encode_audio2(c, &pkt, frame, &got_packet);
    if (ret < 0) {
        fprintf(stderr, "Error encoding audio frame: %s\n", av_err2str(ret));
        exit(1);
    }

    if (got_packet) {
        ret = write_frame(oc, &c->time_base, ost->st, &pkt);
        if (ret < 0) {
            fprintf(stderr, "Error while writing audio frame: %s\n",
                    av_err2str(ret));
            exit(1);
        }
    }

    return (frame || got_packet) ? 0 : 1;
}

/**************************************************************/
/* video output */

static AVFrame *alloc_picture(enum AVPixelFormat pix_fmt, int width, int height) {
    AVFrame *picture;
    int ret;

    picture = av_frame_alloc();
    if (!picture)
        return NULL;

    picture->format = pix_fmt;
    picture->width = width;
    picture->height = height;

    /* allocate the buffers for the frame data */
    ret = av_frame_get_buffer(picture, 32);
    if (ret < 0) {
        fprintf(stderr, "Could not allocate frame data.\n");
        exit(1);
    }

    return picture;
}

static void
open_video(AVFormatContext *oc, AVCodec *codec, OutputStream *ost, AVDictionary *opt_arg) {
    int ret;
    AVCodecContext *c = ost->enc;
    AVDictionary *opt = NULL;

    av_dict_copy(&opt, opt_arg, 0);

    /* open the codec */
    ret = avcodec_open2(c, codec, &opt);
    av_dict_free(&opt);
    if (ret < 0) {
        fprintf(stderr, "Could not open video codec: %s\n", av_err2str(ret));
        exit(1);
    }

    /* allocate and init a re-usable frame */
    ost->frame = alloc_picture(c->pix_fmt, c->width, c->height);
    if (!ost->frame) {
        fprintf(stderr, "Could not allocate video frame\n");
        exit(1);
    }

    /* If the output format is not YUV420P, then a temporary YUV420P
     * picture is needed too. It is then converted to the required
     * output format. */
    ost->tmp_frame = NULL;
    if (c->pix_fmt == AV_PIX_FMT_YUV420P) {
        ost->tmp_frame = alloc_picture(AV_PIX_FMT_ARGB, c->width, c->height);
        if (!ost->tmp_frame) {
            fprintf(stderr, "Could not allocate temporary picture\n");
            exit(1);
        }
    }

    /* copy the stream parameters to the muxer */
    ret = avcodec_parameters_from_context(ost->st->codecpar, c);
    if (ret < 0) {
        fprintf(stderr, "Could not copy the stream parameters\n");
        exit(1);
    }
}


static int decodeIndex(int packedPixel) {
    return (packedPixel >> 8) & 0xFFFF;
}

static int decodeX(int packedPixel, int width) {
    return decodeIndex(packedPixel) % width;
}

static int decodeY(int packedPixel, int width) {
    return (decodeIndex(packedPixel) - decodeX(packedPixel, width)) / width;
}

static int decode_palette_index(int packedPixel) {
    return packedPixel & 0xFF;
}

/* Prepare a dummy image. */
void VideoCreator::fill_yuv_image(AVFrame *pict, int frame_index,
                                  int width, int height, uint32_t *history) {


    int half_width = (width + 1) / 2;
    int half_height = (height + 1) / 2;
    int padding = 0;

    //VideoCreator::argb
    maxIndex = startIndex + speed;
    maxIndex = (maxIndex < totalEdits) ? maxIndex : totalEdits - 1;

    for (int i = startIndex; i < maxIndex; i++) {

        uint32_t historyItem = (uint32_t) history[i];
        int xy = decodeIndex(historyItem);
        int paletteIndex = decode_palette_index(history[i]);
        int color = palette[paletteIndex];


        uint8_t a, r, g, b;

        // argb  <- BGRA
        a = (uint8_t) ((color >> 24) & 0xff);
        r = (uint8_t) ((color >> 16) & 0xff);
        g = (uint8_t) ((color >> 8) & 0xff);
        b = (uint8_t) ((color) & 0xff);

        argb[xy * 4 + 3] = b;
        argb[xy * 4 + 2] = g;
        argb[xy * 4 + 1] = r;
        argb[xy * 4] = a;


        /*
        libyuv::ARGBToI420(argb, width * 4, pict->data[0], width,
                           (uint8_t *)pict->data[1], half_width,
                (uint8_t *) pict->data[2], half_width,
                           width, height);
                    */
        // libyuv::SplitUVRow_C(buffer_uv,pict->data[1], pict->data[2], width);


    }

    /*
    for(int i=0;i<40000;i++){
        pict->data[0][i]= argb[i];
    }
     */

    pict->data[0] = argb;
    vc->video_st.tmp_frame->data[0] = argb;
    // memcpy(pict->data[0],argb, 40000);
    startIndex += speed;

    // fill src argb buffer from history file
    // convert to yuv420p (nv21)
    // write into pict->data







}


static AVFrame *get_video_frame(OutputStream *ost, uint32_t *history) {
    AVCodecContext *c = ost->enc;

    /* check if we want to generate more frames */
    if (av_compare_ts(ost->next_pts, c->time_base,
                      vc->totalTime, (AVRational) {1, 1}) >= 0)
        return NULL;

    /* when we pass a frame to the encoder, it may keep a reference to it
     * internally; make sure we do not overwrite it here */
    if (av_frame_make_writable(ost->frame) < 0)
        exit(1);

    if (c->pix_fmt == AV_PIX_FMT_YUV420P) {
        /* as we only generate a YUV420P picture, we must convert it
         * to the codec pixel format if needed */

        int stride = 4 * vc->width;
        int srcW = vc->width;
        int srcH = vc->height;

        if (!ost->sws_ctx) {
            ost->sws_ctx = sws_getContext(srcW, srcH,
                                          AV_PIX_FMT_ARGB,
                                          640, 640,  // todo, target res variable
                                          AV_PIX_FMT_YUV420P,
                                          SCALE_FLAGS, NULL, NULL, NULL);
            if (!ost->sws_ctx) {
                fprintf(stderr,
                        "Could not initialize the conversion context\n");
                exit(1);
            }
        }


        vc->fill_yuv_image(ost->tmp_frame, ost->next_pts, c->width, c->height, history);
        sws_scale(ost->sws_ctx, (const uint8_t *const *) vc->video_st.tmp_frame,
                  new int[1]{stride}/*vc->video_st.tmp_frame->linesize*/, 0, srcH,
                  vc->video_st.frame->data,
                  vc->video_st.frame->linesize);
    } else {
        vc->fill_yuv_image(ost->frame, ost->next_pts, c->width, c->height, history);
    }

    ost->frame->pts = ost->next_pts++;

    return vc->video_st.frame;
}

/*
 * encode one video frame and send it to the muxer
 * return 1 when encoding is finished, 0 otherwise
 */
static int write_video_frame(AVFormatContext *oc, OutputStream *ost, uint32_t *history) {

    //vc = 12;
    int ret;
    AVCodecContext *c;
    AVFrame *frame;
    int got_packet = 0;
    AVPacket pkt = {0};

    c = ost->enc;

    frame = get_video_frame(ost, history);

    av_init_packet(&pkt);

    /* encode the image */
    ret = avcodec_encode_video2(c, &pkt, frame, &got_packet);
    if (ret < 0) {
        fprintf(stderr, "Error encoding video frame: %s\n", av_err2str(ret));
        exit(1);
    }

    if (got_packet) {
        ret = write_frame(oc, &c->time_base, ost->st, &pkt);
    } else {
        ret = 0;
    }

    if (ret < 0) {
        fprintf(stderr, "Error while writing video frame: %s\n", av_err2str(ret));
        exit(1);
    }

    return (frame || got_packet) ? 0 : 1;
}

static void close_stream(AVFormatContext *oc, OutputStream *ost) {
    avcodec_free_context(&ost->enc);
    av_frame_free(&ost->frame);
    av_frame_free(&ost->tmp_frame);
    sws_freeContext(ost->sws_ctx);
    swr_free(&ost->swr_ctx);
}

/**************************************************************/
/* media file output */


/* excepts file stream which is already opened */
long get_filesize(FILE *fp) {
    long filesize;

    if (fseek(fp, 0, 2) != 0)
        exit(EXIT_FAILURE); /* exit with errorcode if fseek() fails */

    filesize = ftell(fp);

    rewind(fp);

    return filesize;
}


// decodes bytes from =*DART*= (UInt32Array->Int32Array->) -> =*JAVA*= (int[]  32-bit-signed ) -> c
static void decodeOriginal(uint8_t **dst, uint32_t **packed, uint32_t **palette, int width, int height) {

    // all  *array arguments are accessed by *reference, not value;
    for (int i = 0,k=0; i < width * height; i++,k+=4) {

        // obtain uint32 color packed in dart BGRA[8888]
        int palette_index = decode_palette_index((*packed)[i]);
        uint32_t color =  (*palette)[palette_index];

        uint8_t a, r, g, b;

        // argb  <- BGRA
         a = (uint8_t) ((color >> 24) & 0xff); // unused if grayscale
        r = (uint8_t) ((color >> 16) & 0xff);
        g = (uint8_t) ((color >> 8) & 0xff);
        b = (uint8_t) ((color) & 0xff);

        // gray scale
        uint8_t sum =  std::max((r+g+b)/3, 100);
        (*dst)[k] = 100;      // A
        (*dst)[k + 1] = sum;  // R
        (*dst)[k + 2] = sum;  // G
        (*dst)[k + 3] = sum;  // B
    }
}



int VideoCreator::run_encoding(const char *_path,const char* video_path, uint32_t *_argb, uint32_t *_palette, int _width,
                               int _height, int timePaint,int timeShow) {


    vc = new VideoCreator();
    vc->palette = (uint32_t *) _palette;

    vc->height = _height;
    vc->width = _width;

    vc->argb = new uint8_t[_height * _width * 4]; // 4 bytes per pixel in case of RGBA
    decodeOriginal(&(vc->argb), &_argb, &_palette, _width,_height);

           /*
    for (int i = 0; i < _width * _height * 4; i += 4) {

        uint32_t packed = (uint32_t) ( _argb[i]  |   (_argb[i+1]  << 8)| ( _argb[i+2] << 16)|  (_argb[i+3] << 24));

        int paletteIndex = decode_palette_index(packed) ;
        int color = vc->palette[paletteIndex];


        uint8_t a, r, g, b;

        // argb  <- BGRA
        a = (uint8_t) ((color >> 24) & 0xff   );
        r = (uint8_t) ((color >> 16) & 0xff );
        g = (uint8_t) ((color >> 8) & 0xff  );
        b = (uint8_t) ((color) & 0xff );

        // gray scale
        int sum = (r+g+b ) / 3;
        vc->argb[i] = 100;
        vc->argb[i + 1] = sum;
        vc->argb[i + 2] = sum;
        vc->argb[i + 3] = sum;
    }
            */


    vc->video_st = {0};
    OutputStream audio_st = {0};
    const char *filename, *history;
    AVOutputFormat *fmt;
    AVFormatContext *oc;
    AVCodec *audio_codec, *video_codec;
    int ret;
    int have_video = 0, have_audio = 0;
    int encode_video = 0, encode_audio = 0;
    AVDictionary *opt = NULL;
    int i;


    filename = video_path;
    FILE *hfp;
    history = _path;

    hfp = fopen(history, "rb");
    long file_size;
    uint32_t *buffer;
    file_size = get_filesize(hfp);

    vc->maxIndex = (int) file_size - 1;

    // vc->totalFrames = file_size;
    vc->totalTime = timePaint+timeShow;
    vc->desiredFrameLengthMs = 1000 / 25;
    vc->totalFrames = timePaint * 1000 / vc->desiredFrameLengthMs;
    vc->totalEdits = (int) file_size / 4;
    vc->speed = vc->totalEdits / vc->totalFrames;

    size_t size = (size_t) file_size / 4;

    buffer = (uint32_t *) malloc(size * 4);
    if (buffer == NULL) exit(EXIT_FAILURE);


    size_t read = (fread(buffer, sizeof(uint32_t), size, hfp));
    /* checking the fread return value is not necessary but recommended */
    if (read != size)
        exit(EXIT_FAILURE);

    fclose(hfp);

    /* ===== use the file here ===== */

    /* allocate the output media context */
    avformat_alloc_output_context2(&oc, NULL, NULL, filename);
    if (!oc) {
        printf("Could not deduce output format from file extension: using MPEG.\n");
        avformat_alloc_output_context2(&oc, NULL, "mpeg", filename);
    }
    if (!oc)
        return 1;

    fmt = oc->oformat;


    /* Add the audio and video streams using the default format codecs
     * and initialize the codecs. */
    if (fmt->video_codec != AV_CODEC_ID_NONE) {
        fmt->video_codec = AV_CODEC_ID_H264;
        add_stream(&(vc->video_st), oc, &video_codec, fmt->video_codec);
        have_video = 1;
        encode_video = 1;
    }
    if (fmt->audio_codec != AV_CODEC_ID_NONE) {
        add_stream(&audio_st, oc, &audio_codec, fmt->audio_codec);
        have_audio = 1;
        encode_audio = 1;
    }




    /* Now that all the parameters are set, we can open the audio and
     * video codecs and allocate the necessary encode buffers. */
    if (have_video)
        open_video(oc, video_codec, &(vc->video_st), opt);

    if (have_audio)
        open_audio(oc, audio_codec, &audio_st, opt);

    av_dump_format(oc, 0, filename, 1);

    /* open the output file, if needed */
    if (!(fmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&oc->pb, filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            fprintf(stderr, "Could not open '%s': %s\n", filename,
                    av_err2str(ret));
            return 1;
        }
    }

    /* Write the stream header, if any. */
    ret = avformat_write_header(oc, &opt);
    if (ret < 0) {
        fprintf(stderr, "Error occurred when opening output file: %s\n",
                av_err2str(ret));
        return 1;
    }

    vc->video_st.enc->pix_fmt = AV_PIX_FMT_YUV420P;

    while (encode_video || encode_audio) {
        /* select the stream to encode */
        if (encode_video &&
            (!encode_audio || av_compare_ts(vc->video_st.next_pts, vc->video_st.enc->time_base,
                                            audio_st.next_pts, audio_st.enc->time_base) <= 0)) {
            encode_video = !write_video_frame(oc, &vc->video_st, buffer);
        } else {
            encode_audio = !write_audio_frame(oc, &audio_st);
        }
    }

    /* Write the trailer, if any. The trailer must be written before you
     * close the CodecContexts open when you wrote the header; otherwise
     * av_write_trailer() may try to use memory that was freed on
     * av_codec_close(). */
    av_write_trailer(oc);

    free(buffer); /* remember to free the memory */

    /* Close each codec. */
    if (have_video)
        close_stream(oc, &(vc->video_st));
    if (have_audio)
        close_stream(oc, &audio_st);

    if (!(fmt->flags & AVFMT_NOFILE))
        /* Close the output file. */
        avio_closep(&oc->pb);

    /* free the stream */
    avformat_free_context(oc);

    return 0;
}


#pragma clang diagnostic pop