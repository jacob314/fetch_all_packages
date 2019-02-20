    # @formatter:off

    # Sets the minimum version of CMake required to build the native library.

    cmake_minimum_required(VERSION 3.4.1)




    #--------------------______/.||||       OPEN H264        ||||.\________------------------------#
#
 #                               # Cisco OpenH264 native compiled .so lib
#
 #   # define    var         for path to files in project
 #   set(        oh264_DIR      ${CMAKE_SOURCE_DIR}/ext-lib/ffmpeg)
#
 #   add_library(openh264    SHARED  IMPORTED)
#
 #   set_target_properties(
 #           openh264    PROPERTIES  IMPORTED_LOCATION ${oh264_DIR}/lib/${ANDROID_ABI}/libopenh264.so)





    #________________________/.||||        QUANTIZATION          ||||.\___________________________#

    # define var holding path to imagequant sources
    set(
            iq_DIR                                      #   key
            ${CMAKE_SOURCE_DIR}/ext-src/libimagequant   #   value
    )


    add_library(
            imagequant  # name
            SHARED      # type

            # source files
            ${iq_DIR}/blur.c
            ${iq_DIR}/kmeans.c
            ${iq_DIR}/libimagequant.c
            ${iq_DIR}/mediancut.c
            ${iq_DIR}/mempool.c
            ${iq_DIR}/nearest.c
            ${iq_DIR}/pam.c
    )

    #--------------------------
    # Also include header files
    #--------------------------
    #target_
    include_directories(


            #PRIVATE         # mode

            ${iq_DIR}/      # imagequant headers
    )
    #________________________/.||||    resample image cpp    ||||.\__________________________#



    # define var holding path to imagequant sources
#   set(
#           ri_DIR                                      #   key
#           ${CMAKE_SOURCE_DIR}/ext-src/libresample   #   value
#   )

#   file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "/ext-src/libresample/*.cpp")

#   add_library(
#           imageresample  # name
#           STATIC      # type

#           # source files
#          ${SOURCES}

#   )
#   SET_TARGET_PROPERTIES(imageresample PROPERTIES LINKER_LANGUAGE CXX)

#   #--------------------------
#   # Also include header files
#   #--------------------------
#   #target_
#   include_directories(


#           #PRIVATE         # mode

#           ${ri_DIR}/      # imagequant headers
#           )

    #________________________/.||||    libYUV COLOR CONVERSION     ||||.\__________________________#


    # define    var                  for path to libyuv sources
   set(        yuv_DIR             ${CMAKE_SOURCE_DIR}/ext-src/yuv/)


   add_library(
           yuv

           SHARED

           # libyuv sources:
           ${yuv_DIR}/compare.cc
           ${yuv_DIR}/compare_common.cc
           ${yuv_DIR}/compare_gcc.cc
           ${yuv_DIR}/compare_mmi.cc
           ${yuv_DIR}/compare_msa.cc
           ${yuv_DIR}/compare_neon.cc
           ${yuv_DIR}/compare_neon64.cc
           ${yuv_DIR}/compare_win.cc
           ${yuv_DIR}/convert.cc
           ${yuv_DIR}/convert_argb.cc
           ${yuv_DIR}/convert_from.cc
           ${yuv_DIR}/convert_from_argb.cc
           ${yuv_DIR}/convert_jpeg.cc
           ${yuv_DIR}/convert_to_argb.cc
           ${yuv_DIR}/convert_to_i420.cc
           ${yuv_DIR}/cpu_id.cc
           ${yuv_DIR}/mjpeg_decoder.cc
           ${yuv_DIR}/mjpeg_validate.cc
           ${yuv_DIR}/planar_functions.cc
           ${yuv_DIR}/rotate.cc
           ${yuv_DIR}/rotate_any.cc
           ${yuv_DIR}/rotate_argb.cc
           ${yuv_DIR}/rotate_common.cc
           ${yuv_DIR}/rotate_gcc.cc
           ${yuv_DIR}/rotate_mmi.cc
           ${yuv_DIR}/rotate_msa.cc
           ${yuv_DIR}/rotate_neon.cc
           ${yuv_DIR}/rotate_neon64.cc
           ${yuv_DIR}/rotate_win.cc
           ${yuv_DIR}/row_any.cc
           ${yuv_DIR}/row_common.cc
           ${yuv_DIR}/row_gcc.cc
           ${yuv_DIR}/row_mmi.cc
           ${yuv_DIR}/row_msa.cc
           ${yuv_DIR}/row_neon.cc
           ${yuv_DIR}/row_neon64.cc
           ${yuv_DIR}/row_win.cc
           ${yuv_DIR}/scale.cc
           ${yuv_DIR}/scale_any.cc
           ${yuv_DIR}/scale_argb.cc
           ${yuv_DIR}/scale_common.cc
           ${yuv_DIR}/scale_gcc.cc
           ${yuv_DIR}/scale_mmi.cc
           ${yuv_DIR}/scale_msa.cc
           ${yuv_DIR}/scale_neon.cc
           ${yuv_DIR}/scale_neon64.cc
           ${yuv_DIR}/scale_win.cc
           ${yuv_DIR}/video_common.cc
   )

   #--------------------------
   # Also include header files
   #--------------------------
   #target_
   include_directories(


           #INTERFACE
           # imagequant headers
           ${yuv_DIR}/include
   )


    #-------------------______/.|||| FFMPEG STATIC PARTS ||||.\________----------------------------#


#    # define    var         for path to files in project
#    set(        ff_DIR      ${CMAKE_SOURCE_DIR}/ext-lib/ffmpeg)
#
#
#    # Importing f   fmpeg native    compiled libs
#    add_library(    avcodec         SHARED      IMPORTED)
#    add_library(    avformat        SHARED      IMPORTED)
#    add_library(    avutil          SHARED      IMPORTED)
#
#    add_library(    swresample      SHARED      IMPORTED)
#    add_library(    swscale         SHARED      IMPORTED)




    # name   # command  # key               # value
#   set_target_properties(
#           avutil  PROPERTIES IMPORTED_LOCATION   ${ff_DIR}/lib/${ANDROID_ABI}/libavutil-56.so)
#
#   set_target_properties(
#           avformat  PROPERTIES IMPORTED_LOCATION   ${ff_DIR}/lib/${ANDROID_ABI}/libavformat-58.so)
#
#   set_target_properties(
#           avcodec  PROPERTIES IMPORTED_LOCATION   ${ff_DIR}/lib/${ANDROID_ABI}/libavcodec-58.so)
#
#   set_target_properties(
#           swscale  PROPERTIES IMPORTED_LOCATION   ${ff_DIR}/lib/${ANDROID_ABI}/libswscale-5.so)
#
#   set_target_properties(
#           swresample  PROPERTIES IMPORTED_LOCATION   ${ff_DIR}/lib/${ANDROID_ABI}/libswresample-3.so)


    #--------------------------
    # FFmpeg libAV's headers
    #--------------------------
    include_directories(${ff_DIR}/lib/${ANDROID_ABI}/include/)




    #-------------------______/.||||         CUSTOM JNI           ||||.\________-------------------#


    #--------------------------
    # jni layer
    #--------------------------
    add_library(
            natives
            SHARED
            # Provides path to source file(s).
            src/main/cpp/native-lib.cpp
            )

    #--------------------------
    # jni headers
    #--------------------------

    include_directories(
          #  native-lib

          # INTERFACE

          # headers
            ${iq_DIR}/
            ${yuv_DIR}/include/
    #        ${ff_DIR}/lib/${ANDROID_ABI}/include/
            ${CMAKE_SOURCE_DIR}/src/main/cpp/jni_nclude/
    )



    #______________________________________________________________________________________________#


    find_library(
            # Sets the name of the path variable.
            log-lib
            # Specifies the name of the NDK library that
            # you want CMake to locate.
            log)


    #______________________________________________________________________________________________#



    #------------------------------------------------------------------
    # Specifies libraries CMake should link to your target library. You
    # can link multiple libraries, such as libraries you define in this
    # build script, prebuilt third-party libraries, or system libraries.
    #------------------------------------------------------------------

    target_link_libraries( # Specifies the target (JNI) library

            #---------------------------------------------------------
            # main entrypoint from Java
            # jni bindings allowing launch other c/c++ code
            natives
            #---------------------------------------------------------


            # Links the target library to the log library
            # included in the NDK.
            ${log-lib}

            #-------------------------------------------------
            # libs being linked to native-lib as dependencies:
            #----------     ----------------------------------
           imagequant      # qntize
           yuv             # Optimized color space conversions
        #   swresample      # Audio sampling
        #   swscale         # Resize & Recolor
        #   openh264        # h.264 with LGPL license
        #   avutil          # utils, filters, structures, etc.
        #   avcodec         # encoders & decoders
        #   avformat        # muxers, containers, formats






            )