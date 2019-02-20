//
//  ChatboardFileInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/29.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardFileInterface_hpp
#define ChatboardFileInterface_hpp

#include <stdio.h>
#include <string>
#include "latitech_whiteboard_sdk.h"
#include "UIInterface.h"
#include "InterfaceDefine.hpp"

namespace CBIO
{
    using namespace std;
    using namespace latitech::whiteboard;
    class ChatboardFileInterface
    {
    public:
        static ChatboardFileInterface * instance();
        
        virtual ~ChatboardFileInterface() = default;
        
    public:
        
        /**
         更新资源状态

         @param _guid ID
         @param _status 状态
         @param _param1 参数
         @param _param2 参数
         @param _data 数据
         @return 返回值
         */
        static bool
        updateResourceStatus(const char *_guid, SyncStatus _status, int _param1, float _param2,
                             void *_data);
        /**
         白板中回传文件
         
         @return success or fail
         */
        static std::string callbackPassServerFile();
        
        /// 向白板插入本地文件
        /// \param _resId 资源id
        /// \param _name 文件名称
        /// \param _md5 MD5
        /// \param _localPath 文件路径
        /// \param _left 左边偏移
        /// \param _top 顶边偏移
        /// \param _width 文件宽度
        /// \param _height 文件高度
        static void
        insertFileToWhiteBoard(const char *_resId, const char *_name, const char *_md5,
                               const char *_localPath,
                               int _left, int _top, int _width, int _height);
        
        
        /**
         插入文本

         @param _id ID
         @param _text 文本
         @param _color 颜色
         @param _bgcolor 背景色
         @param _size 字体大小
         @param _left 左
         @param _top 上
         @param _width 宽
         @param _height 高
         */
        static void insertTextViewToWhiteBoard(const char *_id, const char *_text, const char *_color, const char *_bgcolor, int _size, int _left, int _top, int _width, int _height);
        
        /**
         通知白板刷新文本

         @param _id ID
         @param _text 文本
         @param _color 颜色
         @param _bgcolor 背景色
         @param _size 字体大小
         @param _left 左
         @param _top 上
         @param _width 宽
         @param _height 高
         */
        static void notifyWhiteBoardLoadTextImage(const char *_id, const char *_text, const char *_color, const char *_bgcolor, int _size, int _left, int _top, int _width, int _height,const char * _targetId);
        
        /// 向白板插入云盘文件
        /// \param _resId 资源id
        /// \param _name 文件名称
        /// \param _md5 MD5
        /// \param _left 左边偏移
        /// \param _top 顶边偏移
        /// \param _width 文件宽度
        /// \param _height 文件高度
        static void insertCloudFileToWhiteBoard(const char *_resId, const char *_name, const char *_md5, int _left, int _top, int _width, int _height);
        
        /**
         删除文本

         @param _action 动作
         @param parameter 参数
         */
        static void processDeleteText(UIBarAction _action, string parameter,string targetId);
    };
}

#endif /* ChatboardFileInterface_hpp */
