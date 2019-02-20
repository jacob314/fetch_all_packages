//
// Created by Yuri Komlev on 20.10.2018.
//

#include <libavutil/frame.h>

#include <libavutil/avassert.h>
#include <libavutil/channel_layout.h>
#include <libavutil/opt.h>
#include <libavutil/mathematics.h>
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>

typedef struct OutputStream {
    AVStream *st;
    AVCodecContext *enc;

    // pts of the next frame that will be generated
    int64_t next_pts;
    int samples_count;

    AVFrame *frame;
    AVFrame *tmp_frame;

    float t, tincr, tincr2;

    struct SwsContext *sws_ctx;
    struct SwrContext *swr_ctx;
} OutputStream;
class VideoCreator {
public:
    static int run_encoding(const char *,const char*, uint32_t * _argb, uint32_t* palette, int _width, int height, int timePaint,int timeShow);

    // from flutter
    uint32_t* palette;
    int width;
    // original image grey-scaled argb
    uint8_t *argb;
    int height;

    int totalFrames;
    int desiredFrameLengthMs = 420;

    int totalTime;

    int totalEdits; // historylength

    int totalKeyframes;

    int speed = 100;
    int maxIndex;
    int startIndex;

    OutputStream video_st = {0};
    void fill_yuv_image(AVFrame *pict, int frame_index, int width, int height, uint32_t* history);
};


