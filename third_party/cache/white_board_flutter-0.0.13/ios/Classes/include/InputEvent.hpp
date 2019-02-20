//
//  InputEvent.hpp
//  ChatboardCore
//
//  Created by mac zhang on 04/02/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef InputEvent_hpp
#define InputEvent_hpp

#include "bitmask_operators.hpp"

namespace CBIO
{

enum class InputSource {
    Stylus = 0x01,
    Touch = 0x02,
    LeftMouse = 0x04,
    RightMouse = 0x08,
    KeyboardControl = 0x10,
    Mouse = 0x20
};

enum class InputEvent {
    TouchBegin,
    TouchMove,
    TouchEnd,
    TouchCancel,
    Stationary,
    LongTouch,
    Tap,
    Pan,
    Manipulation,
    MouseMove,
    MouseWheel
};

enum class GestureType {
    None,         //没有手势
    Touch,        //touch手势
    Panning,      //拖动手势
    Manipulation, //缩放+拖动手势
    Zoom,         //缩放手势
    Click,        //点击手势
    MouseMove,
    Swipe
};
} // namespace CBIO

template<>
struct enable_bitmask_operators<CBIO::InputSource>{
    static const bool enable=true;
};

#endif /* InputEvent_hpp */
