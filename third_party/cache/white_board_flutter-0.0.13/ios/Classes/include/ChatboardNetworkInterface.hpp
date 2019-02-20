//
//  ChatboardNetworkInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/30.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardNetworkInterface_hpp
#define ChatboardNetworkInterface_hpp

#include <stdio.h>
#include "latitech_whiteboard_sdk.h"
#include <string>

namespace CBIO
{
    using namespace std;
    using namespace latitech::whiteboard;
    
    class ChatboardNetworkInterface
    {
    public:
        static ChatboardNetworkInterface * instance();
        
        virtual ~ChatboardNetworkInterface() = default;
        
    public:
        /// 网络连接成功
        /// \param callback 回调函数
        static void onSessionConnected(fp_session_connected_cb callback);
        
        /// 网络中断
        /// \param callback 回调函数
        static void onSessionAborted(fp_session_aborted_cb callback);
        
        // WebSocket重连成功
        static void onSessionReconnectedOk(fp_session_reconnected_ok_cb callback);
        
        // WebSocket重连
        static void onSessionReconnecting(fp_session_reconnected_cb callback);
        
        /// 发送ping帧
        static void sendPing();
    };
}

#endif /* ChatboardNetworkInterface_hpp */
