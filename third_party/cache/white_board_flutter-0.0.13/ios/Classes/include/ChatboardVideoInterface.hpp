//
//  ChatboardVideoInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/30.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardVideoInterface_hpp
#define ChatboardVideoInterface_hpp

#include <stdio.h>
#include <string>

namespace CBIO
{
    using namespace std;
    class ChatboardVideoInterface
    {
    public:
        static ChatboardVideoInterface * instance();
        
        virtual ~ChatboardVideoInterface() = default;
        
    public:
        /// 推送视频流的接口
        static void
        onVideoFrameReady(const char *_targetId, unsigned char *_yBuffer, unsigned char *_uBuffer,
                          unsigned char *_vBuffer, int _frameWidth, int _frameHeight);
        
        /// 创建直播窗口
        /// \param live_id 视频流id
        /// \param x 顶点X坐标
        /// \param y 顶点Y坐标
        /// \param w 窗口宽度
        /// \param h 窗口高度
        static void createLiveWindow(string live_id, int x, int y, int w, int h);
        
        /// 移除直播窗口
        /// \param live_id 视频流id
        static void removeLiveWindow(string live_id);
        
        /// 直播推流yuv格式
        /// \param videoId 视频流id
        /// \param y y信道数据
        /// \param u u信道数据
        /// \param v v信道数据
        /// \param w 帧宽度
        /// \param h 帧高度
        static void
        renderVideoFrameYuv(const char *videoId, const unsigned char *y, const unsigned char *u,
                            const unsigned char *v, int w, int h, int angle, bool isMiror);

        static void
        insertVideoStreamToWhiteBoard(const char *_path, const char *_guid, int _streamWidth,
                                      int _streamHeight, int _left, int _top, int _width,
                                      int _height);
    };
}

#endif /* ChatboardVideoInterface_hpp */
