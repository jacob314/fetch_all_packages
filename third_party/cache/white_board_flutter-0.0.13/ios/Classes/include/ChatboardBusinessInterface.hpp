//
//  ChatboardBusinessInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/29.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardBusinessInterface_hpp
#define ChatboardBusinessInterface_hpp

#include <stdio.h>
#include "latitech_whiteboard_sdk.h"
#include <string>

namespace CBIO
{
    using namespace std;
    using namespace latitech::whiteboard;
    class ChatboardBusinessInterface
    {
    public:
        static ChatboardBusinessInterface * instance();
        
        virtual ~ChatboardBusinessInterface() = default;
        
    public:
        
        /// 进入白板，网络线程
        /// \param _topicId 白板id
        /// \return 执行结果
        static bool enterTopic(const char *_topicId);
        
        /// 离开白板，网络线程
        /// \param _topicId 白板id
        /// \return 执行结果
        static bool leaveTopic(const char *_topicId);
        
        /// 登录sdk服务器，网络线程
        /// \param _userId 用户id
        /// \param _sessionId 用户会话id
        /// \return 登录状态结果[latitech::whiteboard::error::ok]表示成功
        static int login(const std::string &_userId, const std::string &_sessionId);
        
        /// 注销sdk服务器，网络线程
        static void logout();
        
        /// 收到聊天消息
        /// \param callback 回调函数
        static void onChatMessageReceived(fp_chatmsg_recvd_cb callback);
        
        /**
         收到webrtc消息
         
         @param callback 回调函数
         */
        static void onWebrtcMessageReceived(fp_webrtc_recvd_cb callback);
        
        /// On Mesasge ack received
        /// \param callback callback
        static void onChatAckReceived(fp_chatack_recvd_cb callback);
        
        /// 发送聊天消息
        /// \param sessionId 用户会话id
        /// \param data 消息数据
        /// \return 发送结果
        static int sendChatMessage(const std::string &sessionId, const std::string &data);
        
        /**
         发送webrtc消息
         
         @param data 消息数据
         @return 发送结果
         */
        static int sendWebrtcMessage(const std::string &data);
        
        /**
         进入聊天室
         
         @param sessionId 用户会话id
         @param chatRoomId 房间id
         */
        static void joinChatRoom(const std::string &sessionId, const std::string &chatRoomId);
        
        /// 离开聊天室
        /// \param sessionId 用户会话id
        /// \param chatRoomId 房间id
        /// \return 响应字符串
        static std::string
        leaveChatRoom(const std::string &sessionId, const std::string &chatRoomId);
        
        /// 获取聊天消息
        /// \param sessionId 用户会话id
        /// \param roomId 房间id
        /// \param messageId 消息id
        /// \return 响应字符串
        static std::string getChatMessages(const std::string &sessionId, const std::string &roomId,
                                           const std::string &messageId);
        
        /**
         获取页面数据
         
         @return data
         */
        static string getDocumentPageJson();
        
        /**
         人员信息通知
         
         @param _accountId ID
         @param _nickName 昵称
         @param _headImageBuffer 头像二进制
         @param _code 1 成功，0失败，-----失败值为空,nullptr
         */
        static void personInfoReceive(int _code, string _accountId, string _nickName,
                                      unsigned char *_headImageBuffer);
    };
}

#endif /* ChatboardBusinessInterface_hpp */
