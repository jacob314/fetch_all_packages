//
//  ChatboardMenuInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/29.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardMenuInterface_hpp
#define ChatboardMenuInterface_hpp

#include <stdio.h>
#include <string>
#include "InterfaceDefine.hpp"
#include "UIInterface.h"

namespace CBIO
{
    class ChatboardMenuInterface
    {
    public:
        static ChatboardMenuInterface * instance();
        
        virtual ~ChatboardMenuInterface() = default;
    public:
        /**
         移动放大镜到下一个位置
         */
        static void changeZoomNextPosition();
        
        /**
         移动放大镜到上一个位置
         */
        static void changeZoomLastPosition();
        
        /**
         移动放大镜到下一行
         */
        static void changeZoomNewLinePosition();
        
        /**
         获取放大镜的倍数
         
         @return scale
         */
        static float getMagnifyScale();
        
        /**
         设置放大镜的倍数
         
         @param _scale scale
         */
        static void setMagnifyScale(float _scale);
        
        /// 配置当前屏幕的输入模式,包括笔\橡皮\放大镜等
        /// \param _screenType 当前屏幕的屏幕类型
        /// \param _mode 当前的输入类型
        static void updateInputMode(ScreenType _screenType, InputMode _mode);
        
        /// 配置当前的笔输入模式
        /// \param _penType 代表笔的种类,0,是正常的笔,1是马克笔,2是激光笔
        /// \param _color 表示笔的颜色,用#aarrggbb的样式来表示
        /// \param _size 表示笔的宽度
        static void updatePenStyle(int _penType, string &_color, int _size);
        
        /// 白板控制命令
        /// \param _action 命令
        static void processUICommand(UIBarAction _action, string parameter = "");
        
        /**
         离开全屏模式
         */
        static void processLeaveFullScreen();
    };
}

#endif /* ChatboardMenuInterface_hpp */
