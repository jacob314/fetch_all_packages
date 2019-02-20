//
//  UIInterface.m
//  MeetingGroup
//
//  Created by zzx on 2018/3/15.
//  Copyright © 2018年 陈凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "UIInterface.h"
#import "ChatboardInterface.h"
#import "NSObject+Json.h"
#import "WhiteBoardFlutterPlugin.h"
#import "NSString+MD5.h"

namespace CBIO {
    
    void UIInterface::enterSingleViewMode(WidgetType _widgetType,string _id,string _title,vector<UIBarAction> _action,page_controller_info _pageInfo)
    {
        NSMutableArray *actions = [NSMutableArray array];
        for(UIBarAction action :_action)
        {
            switch(action){
                case UIBarAction::Draw:
                    [actions addObject:@(0)];
                    break;
                case UIBarAction::Erase:
                    [actions addObject:@(1)];
                    break;
                case UIBarAction::EnterZoom:
                    [actions addObject:@(2)];
                    break;
                case UIBarAction::LeaveZoom:
                    [actions addObject:@(3)];
                    break;
                case UIBarAction::Rotate:
                    [actions addObject:@(4)];
                    break;
                case UIBarAction::Save:
                {
                    [actions addObject:@(5)];
                }
                    break;
                case UIBarAction::PageDown:
                    [actions addObject:@(6)];
                    break;
                case UIBarAction::PageUp:
                    [actions addObject:@(7)];
                    break;
                case UIBarAction::GotoPage:
                    [actions addObject:@(8)];
                    break;
                case UIBarAction::WidgetPageDown:
                    [actions addObject:@(9)];
                    break;
                case UIBarAction::WidgetPageUp:
                    [actions addObject:@(10)];
                    break;
                case UIBarAction::Delete:
                    [actions addObject:@(11)];
                    break;
                case UIBarAction::NewPage:
                    [actions addObject:@(12)];
                    break;
            }
        }
        
        NSString * title=[NSString stringWithCString:_title.c_str() encoding:NSUTF8StringEncoding];
        NSString * widgetId = [NSString stringWithCString:_id.c_str() encoding:NSUTF8StringEncoding];
        int type = 0;
        switch (_widgetType)
        {
            case WidgetType::Office:
                type = 0;
                break;
            case WidgetType::Image:
                type = 1;
                break;
            case WidgetType::Memo:
                type = 2;
                break;
            case WidgetType::Video:
                type = 3;
                break;
            case WidgetType::Text:
                type = 4;
                break;
            default:
                break;
        }
        
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onEnterSingleViewMode" andParams:@{@"widgetType":[NSNumber numberWithInt:type],@"id":widgetId,@"name":title,@"actions":actions,@"currentPageNumber":[NSNumber numberWithInt:_pageInfo._current_page_no],@"pageCount":[NSNumber numberWithInt:_pageInfo._page_count_no],@"isFlip":[NSNumber numberWithBool:_pageInfo._flip_allowed]}];
    }
    
    void UIInterface::fileWidgetChange(page_controller_info _pageInfo)
    {
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onWidgetNumberChange" andParams:@{@"currentPageNumber":[NSNumber numberWithInt:_pageInfo._current_page_no],@"totalPageNumber":[NSNumber numberWithInt:_pageInfo._page_count_no],@"flipable":[NSNumber numberWithBool:_pageInfo._flip_allowed]}];
    }
    
    void UIInterface::leaveSingleViewMode()
    {
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onLeaveSingleViewMode" andParams:nil];
    }
    void UIInterface::onPageNumberChanged(int _currentPageNumber, int _totalPageNumber, bool _isPage)
    {
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onPageList" andParams:@{@"currentPageNumber":[NSNumber numberWithInt:_currentPageNumber],@"totalPageNumber":[NSNumber numberWithInt:_totalPageNumber]}];
    }
    
    void UIInterface::getPersonInfoWithAccountId(string _accountId)
    {
        
    }
    
    void UIInterface::getChatfilereturnJson(const char* _callback)
    {
        
    }
    
    void UIInterface::whiteBoardEnterMagnifyMode()
    {
        
    }
    void UIInterface::chatDownloadFinished(const std::string& resourceid,const std::string& filename)
    {
        
    }
    
    void UIInterface::chatDownloadFault(const std::string& resourceid,const std::string& reason)
    {
        
    }
    void UIInterface::chatDownloadProgressChanged(const std::string& resourceid,uint_least64_t bytesReceived,
                                            uint_least64_t totalBytes)
    {
        
    }
    
    void UIInterface::whiteBoardPersonList(const std::string &_personListStr)
    {
        NSString *string = [NSString stringWithCString:_personListStr.c_str() encoding:NSUTF8StringEncoding];
        NSArray *array = [NSObject jsonStringToArray:string];
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onUserList" andParams:array];
    }
    
    void UIInterface::whiteBoardPersonIsOnline(const std::string &_accountId,int _isOnline,const std::string &_sessionId)
    {
        if(_isOnline == 0)
        {
            [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onUserLeave" andParams:@{@"accountId":[NSString stringWithCString:_accountId.c_str() encoding:NSUTF8StringEncoding],@"sessionId":[NSString stringWithCString:_sessionId.c_str() encoding:NSUTF8StringEncoding]}];
        }
        else
        {
            [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onUserJoin" andParams:@{@"accountId":[NSString stringWithCString:_accountId.c_str() encoding:NSUTF8StringEncoding],@"sessionId":[NSString stringWithCString:_sessionId.c_str() encoding:NSUTF8StringEncoding]}];
        }
    }
    
    void UIInterface::whiteBoardRemoveParticipant(const std::string &_accountIdStr)
    {
        
    }
    
    void UIInterface::whiteBoardNewParticipantArrive(const std::string &_newParticipantStr)
    {
        
        
    }
    
    void UIInterface::onReceiveSaveFilePath(const std::string & _path,const std::string & _resourceId,const std::string & _name)
    {
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onSaveFile" andParams:@{@"name":[NSString stringWithCString:_name.c_str() encoding:NSUTF8StringEncoding],@"path":[NSString stringWithCString:_path.c_str() encoding:NSUTF8StringEncoding],@"resourceId":[NSString stringWithCString:_resourceId.c_str() encoding:NSUTF8StringEncoding]}];
    }
    
    void UIInterface::onReceivePageList(const std::string & _json)
    {
        NSString *string = [NSString stringWithCString:_json.c_str() encoding:NSUTF8StringEncoding];
        NSArray *array = [NSObject jsonStringToArray:string];
        [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onPageList" andParams:array];
    }
    
    void UIInterface::onReceiveTextView(const std::string _id,const std::string & _text,const std::string &_color,const std::string &_bgColor,int _fontSize,CBIO::TextEventType _type,const std::string _targetId)
    {
        NSString * inputString = [NSString stringWithCString:_text.c_str() encoding:NSUTF8StringEncoding];
        NSString * color = [NSString stringWithCString:_color.c_str() encoding:NSUTF8StringEncoding];
        NSString * bgColor = [NSString stringWithCString:_bgColor.c_str() encoding:NSUTF8StringEncoding];
        NSString * targetId = [NSString stringWithCString:_targetId.c_str() encoding:NSUTF8StringEncoding];
        if(_type == CBIO::TextEventType::TextActivity)
        {
            [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onTextEdit" andParams:@{@"id":[NSString stringWithCString:_id.c_str() encoding:NSUTF8StringEncoding],@"text":inputString,@"color":color,@"backgroundColor":bgColor,@"size":[NSNumber numberWithInt:_fontSize],@"targetId":targetId}];
        }
        else if(_type == CBIO::TextEventType::TextGenerateImage)
        {
            NSString * string = [NSString stringWithFormat:@"%@\n",inputString];
            
            NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            //            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            [paragraphStyle setLineSpacing:[@"我" getStringSizewithStringFont:@{NSFontAttributeName : [UIFont systemFontOfSize:_fontSize]} withWidthOrHeight:823 isWidthFixed:YES].height*0.1];  //行间距
            [paragraphStyle setParagraphSpacing:2.0f];//字符间距
            
            NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:_fontSize],
                                         NSForegroundColorAttributeName : [NSString colorWithHexString:color],
                                         NSBackgroundColorAttributeName : [NSString colorWithHexString:bgColor],
                                         NSParagraphStyleAttributeName : paragraphStyle};
            
            NSString * md5 = [[NSString stringWithFormat:@"%@%@%@%d",inputString,color,bgColor,_fontSize] md5];
            
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",ImageCachePath,md5]])
            {
                UIImage * image = [string imageFromAttributes:attributes size:[string getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES] andMD5:md5 andLineHeight:[@"我" getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES].height];
            }
        }
        else
        {
            NSString * string = [NSString stringWithFormat:@"%@\n",inputString];
            
            NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            //            [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
            [paragraphStyle setLineSpacing:[@"我" getStringSizewithStringFont:@{NSFontAttributeName : [UIFont systemFontOfSize:_fontSize]} withWidthOrHeight:823 isWidthFixed:YES].height*0.1];  //行间距
            [paragraphStyle setParagraphSpacing:2.0f];//字符间距
            
            NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:_fontSize],
                                         NSForegroundColorAttributeName : [NSString colorWithHexString:color],
                                         NSBackgroundColorAttributeName : [NSString colorWithHexString:bgColor],
                                         NSParagraphStyleAttributeName : paragraphStyle};
            
            NSString * md5 = [[NSString stringWithFormat:@"%@%@%@%d",inputString,color,bgColor,_fontSize] md5];
            
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",ImageCachePath,md5]])
            {
                UIImage * image = [string imageFromAttributes:attributes size:[string getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES] andMD5:md5 andLineHeight:[@"我" getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES].height];
                
                [[ChatboardInterface sharedChatboardInterfaceManager] notifyWhiteBoardLoadTextImageWithID:[NSString stringWithCString:_id.c_str() encoding:NSUTF8StringEncoding] andSize:_fontSize andColor:[NSString stringWithCString:_color.c_str() encoding:NSUTF8StringEncoding] andText:[NSString stringWithCString:_text.c_str() encoding:NSUTF8StringEncoding] andRect:CGRectMake(0, 0, image.size.width, image.size.height) andBgColor:[NSString stringWithCString:_bgColor.c_str() encoding:NSUTF8StringEncoding] andTargetId:[NSString stringWithCString:_targetId.c_str() encoding:NSUTF8StringEncoding]];
            }
        }
    }
}

