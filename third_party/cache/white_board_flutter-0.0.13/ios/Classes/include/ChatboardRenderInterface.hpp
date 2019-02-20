//
//  ChatboardRenderInterface.hpp
//  ChatboardCore
//
//  Created by 陈凯 on 2018/10/29.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ChatboardRenderInterface_hpp
#define ChatboardRenderInterface_hpp

#include <stdio.h>
#include <string>
#include <functional>
#include "InterfaceDefine.hpp"
#include "InputEvent.hpp"

namespace CBIO
{
    using namespace std;
    class ChatboardRenderInterface
    {
    public:
        static ChatboardRenderInterface * instance();
        
        virtual ~ChatboardRenderInterface() = default;
        
    public:
        /// 初始化白板渲染环境，需要上层在opengl环境准备好后执行，多屏幕应用仅需执行一次初始化工作，渲染线程
        /// \param _type 渲染器类型
        static void initalizeRender(RenderType _type);
        
        /// 创建绘图屏幕（初始化白板控件），需要在[initalizeRender(RenderType)]之后调用，
        /// [prepareContext()]之前调用，渲染线程
        ///
        /// \param _type 屏幕类型
        /// \param _identify 屏幕标签
        /// \param _width 画板控件宽
        /// \param _height 画板控件高
        /// \return 创建结果
        static bool createScreen(ScreenType _type, const char *_identify, int _width, int _height);
        
        /**
         设置是否翻转
         
         @param _isFilp 翻转
         */
        static void setFilp(bool _isFilp);
        
        /// 更新放大镜屏幕大小，渲染线程
        /// \param _width 新宽度
        /// \param _height 新高度
        static void updateAssistantScreen(int _width, int _height);
        
        /// 更新主屏幕大小，渲染线程
        /// \param _name 屏幕名称
        /// \param _width 新宽度
        /// \param _height 新高度
        static void updateScreenSize(string _name, int _width, int _height);
        
        /// 关闭绘图屏幕（离开或移除一个白板控件）
        /// \param _identify 屏幕标签
        static void closeScreen(const char *_identify);
        
        /// 绘制一帧，渲染线程
        /// \param _identify 屏幕标签
        /// \return 绘制结果
        static bool draw(const char *_identify);
        
        /**
         设置屏幕类型
         
         @param _identifier 屏幕标识符
         @param _type 类型
         */
        static void setScreenType(string _identifier, CBIO::ScreenType _type);
        
        /// 本地用户输入事件
        /// \param _screen 画板标签
        /// \param _source 输入设备类型
        /// \param _event 输入事件类型
        /// \param _id 输入源id
        /// \param _x x坐标
        /// \param _y y坐标
        /// \param _force 压力
        /// \param _ts 时间戳
        /// \return true表示输入事件被处理，false表示输入事件被忽略
        static bool
        processLocalInput(const char *_screen, CBIO::InputSource _source, CBIO::InputEvent _event,
                          int _id, float _x, float _y, float _force, long _ts, double _delta = 0);
        
        /**
         远程数据输入

         @param _remoteAction action
         @return 返回值
         */
        static bool processRemoteInput(const char *_remoteAction);
        
        /// 释放渲染器
        /// \return 执行结果
        static bool clearRenderer();
        
        /**
         设置放大镜遮住下面view的高度
         
         @param _offset 高度值
         */
        static void setAssitantViewOffset(float _offset);
        
        /// 加载渲染资源，需在[initalizeRender(RenderType)]之后，
        /// [createScreen(ScreenType,const char *,int,int)]之前调用，渲染线程
        static void prepareContext();
        
        /// 恢复渲染
        static void onResume();
        
        /**
         刷新屏幕
         */
        static void refreshScreen();
        
        /// 设置渲染模式
        /// \param mode 新的模式，0持续刷新，1主动刷新
        static void setRenderMode(int mode);
        
        /// 设置请求刷新回调
        /// \param requestRender 回调接口
        static void setRequestRender(std::function<void()> requestRender);
    };
}

#endif /* ChatboardRenderInterface_hpp */
