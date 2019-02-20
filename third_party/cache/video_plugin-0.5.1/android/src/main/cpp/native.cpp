
#include <android/log.h>
#include <string>


extern "C" {
#include <jni.h>
#include <malloc.h>
#include "jni_nclude/native.hpp"
#include "jni_nclude/encode_video_c.h"
}

//@formatter:off




/**
 * This method waits for :
 *
 *
 * @param [palette] - int[] 32bits, needs shift to become *!unsigned!* to represent BGRA from Dart
 *
 * @param [argb] - self-coded format, where each pixel represented by bits:
 *          0...7   (     & 0xFF  ) - u_int_8  coded index of color in palette (0-255 max.)
 *          8...23  (<<16 & 0xFFFF) - u_int_16 coded coordinates (0...255*255 max.)
 *          24...   (<<24 & 0xFF  ) - u_int_8 coded bool placement state (0 - misplaced, !=0 placed)
 *
 * @param [history] - string path to file with history (32 bits for 1 edit), same format as  above
 *
 * @param [width,height] - da izi je
 *
 *
 * todo: output path and time total
 */


extern "C" JNIEXPORT jdouble JNICALL
Java_ffive_video_videocreator_videogen_VideoGenerator_historyToVideoJNI(JNIEnv *env, jclass type,
                                                              jintArray argb,
                                                               jstring historyPath,
                                                              jstring videoPath,
                                                              jintArray palette_,
                                                               jint width,
                                                              jint height,
                                                               jint timePaint,
                                                               jint timeShow) {
   const char *hpath = env->GetStringUTFChars(historyPath, 0);
    const char *vpath = env->GetStringUTFChars(videoPath, 0);

   jint *palette = env->GetIntArrayElements(palette_, NULL);
   jint *rgb = env->GetIntArrayElements(argb, NULL);


   // TODO


   VideoCreator::run_encoding(hpath,vpath, (uint32_t *) rgb, (uint32_t *) palette, width, height, timePaint, timeShow);
   env->ReleaseStringUTFChars(historyPath, hpath);
    env->ReleaseStringUTFChars(videoPath, vpath);
   env->ReleaseIntArrayElements(palette_, palette, 0);
   return 0.0;
}

