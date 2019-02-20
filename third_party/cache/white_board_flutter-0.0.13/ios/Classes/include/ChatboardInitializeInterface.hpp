//
//  ChatboardInitializeInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/29.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardInitializeInterface_hpp
#define ChatboardInitializeInterface_hpp

#include <stdio.h>
#include <string>
#include "InterfaceDefine.hpp"

namespace CBIO
{
    using namespace std;
    class ChatboardInitializeInterface
    {
    public:
        static ChatboardInitializeInterface * instance();
        
        virtual ~ChatboardInitializeInterface() = default;
        
    public:
        static void setConfigPath(std::string &_path);
        
        /// 添加各项配置文件路径，需要在[init()]之前设置
        /// \param _key 配置key
        /// \param _filePath 文件路径
        static void addConfigFile(const char *_key, const char *_filePath); //CacheDir   path
        
        /// 配置服务器地址
        /// \param _name 服务器名称(sdk , file)
        /// \param _protocol 协议类型(http/https)
        /// \param _address 服务器地址
        /// \param _port 端口号
        static void addServerConfig(const char *_name, const char *_protocol, const char *_address,
                                    const char *_port);
        
        static void setLocalSessionId(const char *_sessionId);
        
        static void setLocalSenderId(const char *_senderId);
        
        /// 初始化sdk，需要在设置过配置文件路径之后，用户登录之前执行
        /// \return 初始化结果
        static bool init();
        
        static bool inInitFinished();
        
        /// 获取当前用户会话id
        /// \return id字符串
        static std::string sessionId();
        
        /// 获取当前用户id
        /// \return id字符串
        static std::string senderId();
        
        /// 设置白板画布大小，需要在[init()]之后调用，只需设置一次，全局有效，尽可能在[init()]之后立即设置
        /// \param width 宽度像素
        /// \param height 高度像素
        static void setCanvasSize(const int width, const int height);
        
        /// 获取白板画布宽度
        /// \return 宽度像素
        static int getCanvasWidth();
        
        /// 获取白板画布高度
        /// \return 高度像素
        static int getCanvasHeight();
        
        /// 添加预加载文件目录，需要在[init()]之前设置
        /// \param _key 标识
        /// \param _jsonPath 描述文件
        /// \param _imagePath 图片文件
        static void
        addPreloadSpriteSheet(const char *_key, const char *_jsonPath, const char *_imagePath);
    };
}

#endif /* ChatboardInitializeInterface_hpp */

