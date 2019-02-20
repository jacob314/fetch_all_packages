#ifndef LATITECH_WHITEBOARD_SDK_H
#define LATITECH_WHITEBOARD_SDK_H

namespace latitech {
    namespace whiteboard {
        enum error {
            /// 登录成功
            ok = 0,
            /// 认证错误
            session_auth_credential = 1,
            /// 用户id不存在
            session_auth_user_nonexistent = 2,
            /// 用户session错误
            session_auth_session_invalid = 3,
            /// 已经登录
            session_already_registered = 4,
            /// 网络异常
            network_connection = 5,
            /// 服务器炸了
            server_internal = 6,
            /// 加入房间失败
            room_join_failed = 7,
            /// 离开房间失败
            room_leave_failed = 8,
            /// 服务器过载
            server_limit = 9,
            /// 用户主动断开连接
            user_close = 10
        };

        typedef void (*fp_session_connected_cb)();

        typedef void (*fp_session_reconnected_ok_cb)();

        typedef void (*fp_session_reconnected_cb)();

        typedef void (*fp_session_aborted_cb)(const char *, int);

        typedef void (*fp_chatmsg_recvd_cb)(const char *);

        typedef void (*fp_chatack_recvd_cb)(const char *);

        typedef void (*fp_webrtc_recvd_cb)(const char *);
    } // namespace whiteboard
} // namespace latitech
#endif // LATITECH_WHITEBOARD_SDK_H
