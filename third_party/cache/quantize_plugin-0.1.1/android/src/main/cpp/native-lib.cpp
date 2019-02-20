
#include <android/log.h>
#include <string>


extern "C" {
#include <jni.h>
#include <malloc.h>
#include "jni_nclude/native-lib.hpp"
#include <libimagequant.h>

}

#include <libyuv/libyuv.h>
#include <libyuv/scale_argb.h>
//@formatter:off
using namespace libyuv;

extern "C" {

typedef struct quant_params {
    uint16_t width;
    uint16_t height;
    uint8_t dst_num_colors;
    uint8_t dst_quality; // 0-100
    uint8_t dst_min_quality; // 0-100
    bool dither;
    uint8_t dither_lvl;
} quant_params;


#ifdef MEASURE_TIME
#include <time.h>
     clock_t start, end;
     double cpu_time_used;
     #define APPNAME "PIXELD"
#endif





    void resize_rgba(void *srcBuff, void *dstBuf, int srcWidth, int srcHeight, int dstWidth, int dstHeight, int quality) {

        FilterMode  mode;
        switch (quality){
            case 0: mode = FilterModeEnum::kFilterNone;break;
            case 1: mode = FilterModeEnum::kFilterLinear;break;
            case 2: mode = FilterModeEnum::kFilterBilinear;break;
            case 3: mode = FilterModeEnum::kFilterBox;break;
            default: mode = FilterModeEnum::kFilterNone;break;

        }

        ARGBScale((uint8_t *) srcBuff,srcWidth * 4,srcWidth, srcHeight, (uint8_t *) dstBuf,
                          dstWidth * 4, dstWidth, dstHeight, mode);


    }


/** qCfg - desired quantizing parameters
* @see quant_params definition
 *
 * srcBufRGBA - buffer containing every pixel of image (bitmap) as uint32 RGBA color value
 * dstBuf     - buffer to receive indices of quantized image
 *  palette -
 *
 */
bool quantize(void *dstBuf, void *srcBufRGBA, liq_palette *pal, quant_params *qCfg) {

    // check if [Direct Buffer] was allocated from Java side
    if (!(uint8_t *) srcBufRGBA) { return 0; }
    if (!(uint8_t *) dstBuf) { return 0; }



    // quantizer settings holder
    liq_attr *attr = liq_attr_create();


    // configure quantization options
    liq_set_max_colors(attr, qCfg->dst_num_colors);
     liq_set_quality(attr, 0, qCfg->dst_quality);


    // bitmap structure from uncompressed bytes
    liq_image *image = liq_image_create_rgba(attr, srcBufRGBA, qCfg->width, qCfg->height, 0);


    // quantize ( make palette )
    liq_result *res;
    if( LIQ_OK == liq_image_quantize(image, attr, &res)){

        // dither applies after quantization
        if (qCfg->dither) {
                printf("setting dither: %d",qCfg->dither_lvl);

            liq_set_dithering_level(res, (qCfg->dither_lvl / (double) 100.0));
        }


        // result is indices (10k in case of 100x100)
        size_t buffer_size = (size_t) (qCfg->width * qCfg->height);

        // apply and put result from image to provided buffer
        liq_write_remapped_image(res, image, dstBuf, buffer_size);




        // Palette is needed to render resulting image.
        // Palette holds actual colors,
        // represented as [0-256 length] 1D Array

        const liq_palette *palette = liq_get_palette(res);



        pal->count = palette->count;
        for(int i = 0; i< palette->count;i++){

            (&pal->entries[i])->r = (&palette->entries[i])->r;
            (&pal->entries[i])->g = (&palette->entries[i])->g;
            (&pal->entries[i])->b = (&palette->entries[i])->b;
            (&pal->entries[i])->a = (&palette->entries[i])->a;
        }


    } else {


        printf("no auantize params");
    }

    liq_result_destroy(res);
    liq_image_destroy(image);
    liq_attr_destroy(attr);

    return true;
}

}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
extern "C" JNIEXPORT jbyteArray JNICALL
Java_ffive_image_quantizeplugin_Utilities_quantize(JNIEnv *env,
                                        jclass type,
                                        jobject src,
                                        jobject dst,
                                        jint srcW,
                                        jint srcH,
                                        jint width,
                                        jint height,
                                        jint numColors,
                                        jint quality,
                                        jboolean dither,
                                        jint dither_lvl) {

    if (!src || !dst) {
        return 0;
    }

    // take pointers to objects received from Java
    void *srcBuff = env->GetDirectBufferAddress(src);
    void *dstBuff = env->GetDirectBufferAddress(dst);

#ifdef MEASURE_TIME
    start = clock();
#endif

    uint8_t * resizeBuffer = static_cast<uint8_t *>(malloc(static_cast<size_t>(4 * width * height)));

#ifdef MEASURE_TIME
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Time used on malloc resize:  %d", cpu_time_used);
    start = clock();
#endif



    resize_rgba(srcBuff,resizeBuffer,srcW,srcH,width,height,quality);

#ifdef MEASURE_TIME
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Time used on resample:  %d", cpu_time_used);
    start = clock();
#endif

    // Palette is needed to render resulting image.
    // Palette holds actual colors,
    // represented as [0-256 length] 1D Array


    liq_palette *pal_ptr =(liq_palette *) malloc( sizeof(liq_palette));



    quant_params *q_cfg;
    q_cfg = static_cast<quant_params *>(calloc(1, sizeof(q_cfg)));
    q_cfg->height = (uint16_t) height;
    q_cfg->width = (uint16_t) width;
    q_cfg->dst_num_colors = (uint8_t) numColors;
    q_cfg->dst_quality = (uint16_t) 80;
    q_cfg->dst_min_quality = (uint16_t) 0;
    q_cfg->dither = dither;
    q_cfg->dither_lvl = (uint8_t) dither_lvl;

    // Palette is needed to render resulting image.
    // Palette holds actual colors,
    // represented as [0-256 length] 1D Array
#ifdef MEASURE_TIME
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Time used on palette and params:  %d", cpu_time_used);
    start = clock();
#endif

    quantize(dstBuff, resizeBuffer, pal_ptr, q_cfg);

#ifdef MEASURE_TIME
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

    __android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Time used on imagequant:  %d", cpu_time_used);
    start = clock();
#endif


    int i = pal_ptr->count * 4;
    jbyteArray arr = env->NewByteArray(i);

    for (i = 0; i < pal_ptr->count; i++) {
        env->SetByteArrayRegion(arr, i * 4, 4, ((jbyte *) &pal_ptr->entries[i]));
    }

#ifdef MEASURE_TIME
    end = clock();
    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;

__android_log_print(ANDROID_LOG_VERBOSE, APPNAME, "Time used on pass array to java:  %d", cpu_time_used);
    start = clock();
#endif



    //free(srcBuff);
    free(resizeBuffer);
    free(pal_ptr);
    free(q_cfg);
    //env->ReleaseByteArrayElements(srcBuff);



    // todo : fix
    return arr;
}

