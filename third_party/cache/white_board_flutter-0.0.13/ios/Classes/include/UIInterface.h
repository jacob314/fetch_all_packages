//
//  UIInterface.h
//  ChatboardCore
//
//  Created by mac zhang on 15/03/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef UIInterface_h
#define UIInterface_h

#include <string>
#include <vector>
#include "InterfaceDefine.hpp"
#include "PageControlInfo.hpp"

namespace CBIO {
    using namespace std;

    enum class UIBarAction {
        Draw,
        Erase,
        EnterZoom,
        LeaveZoom,
        Rotate,
        Save,
        PageDown,
        PageUp,
        GotoPage,
        WidgetPageDown,
        WidgetPageUp,
        Delete,
        NewPage,
        OnTopicChange,
        EnableVideo,
        DisableVideo,
        CallbackServer,
        ActionStatusMove,
        InsertFirstPage,
        InsertPage,
        RemovePage,
    };


    //this is the abstract defination,all platform implement own function
    class UIInterface {
    public:
        /**
         进入全屏模式

         @param _widgetType widget类型
         @param _id widgetid
         @param _title 名称
         @param _action 动作
         */
        void static enterSingleViewMode(WidgetType _widgetType,string _id,string _title,vector<UIBarAction> _action,page_controller_info _pageInfo);

        /**
         文档翻页传递页码的方法

         @param _pageInfo 页码数据
         */
        void static fileWidgetChange(page_controller_info _pageInfo);
        
        /**
         离开全屏模式
         */
        void static leaveSingleViewMode();
       // void processRemoteData(class QString const &);
        void processRemoteData(class QString const &);

        /**
         白板页改变的时候

         @param _currentPageNumber 当前页数
         @param _totalPageNumber 全部页数
         @param _isPage 是否是页的数量,false是文档的页码
         */
        void static onPageNumberChanged(int _currentPageNumber, int _totalPageNumber, bool _isPage);
        
        /**
         获取人员信息

         @param _accountId id
         */
        void static getPersonInfoWithAccountId(string _accountId);

        /**
         获取上传文件返回josn

         @param _callback 回调函数
         */
        void static getChatfilereturnJson(const char* _callback);
        /**
         下载文件成功
         @param resourceid
         @param filename
         */
        void static chatDownloadFinished(const std::string& resourceid,const std::string& filename);
        /**
         下载文件失败
         @param resourceid
         @param reason
         */
        void static chatDownloadFault(const std::string& resourceid,const std::string& reason);

        /**
         下载文件进度
         @param resourceid
         @param quint64 bytesReceived
         @param quint64 totalBytes
         */
        void static chatDownloadProgressChanged(const std::string& resourceid,std::uint_least64_t bytesReceived,
                                      std::uint_least64_t totalBytes);


        /**
         白板进入放大镜模式---------手机才会触发，手机主屏模式设置为mini
         */
        void static whiteBoardEnterMagnifyMode();


        /**
         白板的人员列表
         */
        void static whiteBoardPersonList(const std::string& _personListStr);
        
        /**
         白板成员在线/离线状态改变

         @param _isOnline 在线状态
         */
        void static whiteBoardPersonIsOnline(const std::string &_accountId,int _isOnline,const std::string &_sessionId);

        /**
         白板新成员加入

         @param _newParticipantStr 新成员数组
         */
        void static whiteBoardNewParticipantArrive(const std::string & _newParticipantStr);
        
        /**
         删除白板成员

         @param _accountIdStr accountId数组
         */
        void static whiteBoardRemoveParticipant(const std::string & _accountIdStr);

        void static onLocalVideoClosed(const std::string & _sessionId);
        
        /**
         收到需要保存文件的路径

         @param _path 路径
         */
        void static onReceiveSaveFilePath(const std::string & _path,const std::string & _resourceId,const std::string & _name);
        
        /**
         收到页结构的数据

         @param _json 数据
         */
        void static onReceivePageList(const std::string & _json);
        
        /**
         收到文本数据生成图片

         @param _text 文本
         @param _color 颜色
         @param _bgColor 背景色
         @param _fontSize 字体
         */
        void static onReceiveTextView(const std::string _id,const std::string & _text,const std::string &_color,const std::string &_bgColor,int _fontSize,CBIO::TextEventType _type,const std::string _targetId);
    };
}

#endif /* UIInterface_h */
