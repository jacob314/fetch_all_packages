//
//  ChatboardInterface.m
//  Pods-Runner
//
//  Created by 陈凯 on 2018/11/28.
//

#import "ChatboardInterface.h"
#include "ChatboardBusinessInterface.hpp"
#include "ChatboardFileInterface.hpp"
#include "ChatboardInitializeInterface.hpp"
#include "ChatboardMenuInterface.hpp"
#include "ChatboardNetworkInterface.hpp"
#include "ChatboardRenderInterface.hpp"
#include "ChatboardVideoInterface.hpp"
#include "WhiteBoardFlutterPlugin.h"
#import "NSString+MD5.h"

@implementation ChatboardInterface

+ (ChatboardInterface *)sharedChatboardInterfaceManager
{
    static ChatboardInterface * formatInstanceModelManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^(){
        formatInstanceModelManager = [[ChatboardInterface alloc] init];
    });
    return formatInstanceModelManager;
}

-(BOOL)initializeChatBoard
{
    if(CBIO::ChatboardInitializeInterface::inInitFinished())
    {
        return true;
    }
    [self loadDefaultConfig];
    
    [self addServerInfo:@"sdkapi" serverAddress:@"conference.efaceboard.cn" serverPort:@"8443" protocol:@"https"];//
    [self addServerInfo:@"sdk" serverAddress:@"conference.efaceboard.cn" serverPort:@"8081" protocol:@"wss"];//
    [self addServerInfo:@"file" serverAddress:@"conference.efaceboard.cn" serverPort:@"8443" protocol:@"https"];
    
//    [self addServerInfo:@"sdkapi" serverAddress:@"192.168.0.24" serverPort:@"8080" protocol:@"http"];//
//    [self addServerInfo:@"sdk" serverAddress:@"192.168.0.24" serverPort:@"8081" protocol:@"ws"];//
//    [self addServerInfo:@"file" serverAddress:@"192.168.0.24" serverPort:@"8080" protocol:@"http"];
    
    CBIO::ChatboardInitializeInterface::init();
    
    latitech::whiteboard::fp_chatmsg_recvd_cb callbackFunc;
    callbackFunc = onChatMessageReceived;
    CBIO::ChatboardBusinessInterface::onChatMessageReceived(callbackFunc);
    
    latitech::whiteboard::fp_webrtc_recvd_cb webrtcCallbackFunc;
    webrtcCallbackFunc = onWebrtcMessageReceive;
    CBIO::ChatboardBusinessInterface::onWebrtcMessageReceived(webrtcCallbackFunc);
    
    /*
     // 连接成功
     latitech::whiteboard::fp_session_connected_cb onSessionConnectedCallBack;
     onSessionConnectedCallBack = onSessionConnected;
     CBIO::ChatboardNetworkInterface::onSessionConnected(onSessionConnectedCallBack);
     */
    
    // 连接断开
    latitech::whiteboard::fp_session_aborted_cb onAbortedFunc;
    onAbortedFunc =onSessionAborted;
    CBIO::ChatboardNetworkInterface::onSessionAborted(onAbortedFunc);
    
    // 正在重连
    latitech::whiteboard::fp_session_reconnected_cb onSessionReconnectingCallBack;
    onSessionReconnectingCallBack = onReconnecting;
    CBIO::ChatboardNetworkInterface::onSessionReconnecting(onSessionReconnectingCallBack);
    
    // 重连成功
    latitech::whiteboard::fp_session_reconnected_ok_cb onReconnectSucceedCallBack;
    onReconnectSucceedCallBack = onReconnectSucceed;
    CBIO::ChatboardNetworkInterface::onSessionReconnectedOk(onReconnectSucceedCallBack);
    
    latitech::whiteboard::fp_chatack_recvd_cb onReceiveAck;
    onReceiveAck=onChatAckReceived;
    CBIO::ChatboardBusinessInterface::onChatAckReceived(onReceiveAck);
    
    return true;
}

void onChatMessageReceived(const char * _str)
{
    NSString * messageStr=[NSString stringWithCString:_str encoding:NSUTF8StringEncoding];
    
    [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onReceiveChatMessage" andParams:@{@"message":messageStr}];
}

void onWebrtcMessageReceive(const char * _str)
{
    
}

void onSessionAborted(const char * _str,int _errorCode)
{
    NSString * disconnectMessageStr=[NSString stringWithCString:_str encoding:NSUTF8StringEncoding];
    
    [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onDisconnect" andParams:@{@"code":@(_errorCode),@"error":disconnectMessageStr}];
}

void onReconnecting()
{
    
}

void onReconnectSucceed()
{
    
}

void onChatAckReceived(const char * _str)
{
    NSString * ackMessageStr=[NSString stringWithCString:_str encoding:NSUTF8StringEncoding];
    
    [[WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager] callMethod:@"onReceiveChatAck" andParams:@{@"ack":ackMessageStr}];
}

-(void)addServerInfo:(NSString *)name serverAddress:(NSString *)address serverPort:(NSString *)port protocol:(NSString *)protocol
{
    const char * _name = [name cStringUsingEncoding:NSUTF8StringEncoding];
    const char * _address = [address cStringUsingEncoding:NSUTF8StringEncoding];
    const char * _port = [port cStringUsingEncoding:NSUTF8StringEncoding];
    const char * _protocol = [protocol cStringUsingEncoding:NSUTF8StringEncoding];
    CBIO::ChatboardInitializeInterface::addServerConfig(_name,_protocol, _address ,_port);
}

-(void)loadDefaultConfig
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSString * logConfigFile = [mainBundle pathForResource:@"logService" ofType:@"json"];
    NSString * localInputConfigFile = [mainBundle pathForResource:@"localInputChain" ofType:@"json"];
    NSString * remoteInputConfigFile = [mainBundle pathForResource:@"remoteInputChain" ofType:@"json"];
    NSString * testFontFile = [mainBundle pathForResource:@"testfont" ofType:@"ttf"];
    
    [self addConfigFile:@"LogService" withValue:logConfigFile];
    [self addConfigFile:@"LocalInputChain" withValue:localInputConfigFile];
    [self addConfigFile:@"RemoteInputChain" withValue:remoteInputConfigFile];
    [self addConfigFile:@"CacheDir" withValue:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"]];
    [self addConfigFile:@"FontPath" withValue:testFontFile];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * loadingAnimationJson = [mainBundle pathForResource:@"LoadingAnimation" ofType:@"json"];
    NSString * loadingAnimationImage = [mainBundle pathForResource:@"LoadingAnimation" ofType:@"png"];
    
    NSString * loadingAnimationKey = @"animation";
    [self addPreloadAsset:loadingAnimationKey withJsonFile:loadingAnimationJson withImageFile:loadingAnimationImage];
}

-(void)addPreloadAsset:(NSString *)key withJsonFile:(NSString *)jsonFile withImageFile:(NSString *)imageFile
{
    CBIO::ChatboardInitializeInterface::addPreloadSpriteSheet([key cStringUsingEncoding:NSUTF8StringEncoding], [jsonFile cStringUsingEncoding:NSUTF8StringEncoding], [imageFile cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)addConfigFile:(NSString *)key withValue:(NSString *)value
{
    CBIO::ChatboardInitializeInterface::addConfigFile([key cStringUsingEncoding:NSUTF8StringEncoding], [value cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)loginChatBoard:(NSString *)accountId andSessionId:(NSString *)sessionId
{

    _accountId = accountId;
    
    _sessionId = sessionId;
    
    int code=CBIO::ChatboardBusinessInterface::login([accountId UTF8String], [sessionId UTF8String]);
    
    /*
     enum error {
     ok = 0,
     session_auth_credential = 1,
     session_auth_user_nonexistent = 2,
     session_auth_session_invalid = 3,
     session_already_registered = 4,
     network_connection = 5,
     server_internal = 6,
     room_join_failed = 7,
     room_leave_failed = 8,
     };
     */
    
    if(code == 0)
    {
        NSLog(@"白板登陆成功");
    }
    else if(code == 4)
    {
        NSLog(@"白板登陆已经登录成功");
    }
    else
    {
        NSLog(@"白板登陆失败       %d",code);
    }
}

-(void)logouChatBoard
{
    CBIO::ChatboardBusinessInterface::logout();
}

-(void)enterTopic:(NSString *)topicId
{
    CBIO::ChatboardBusinessInterface::enterTopic([topicId cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)leaveTopic:(NSString *)topicId
{
    CBIO::ChatboardBusinessInterface::leaveTopic([topicId cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)setMagnifyScale:(float)scale
{
    CBIO::ChatboardMenuInterface::setMagnifyScale(scale);
}

-(float)getMagnifyScale
{
    return CBIO::ChatboardMenuInterface::getMagnifyScale();
}

-(void)insertFileToChatBoard:(NSString *)path
{
    NSString * name = [path lastPathComponent];
    
    NSString * md5 = [NSString getFileMD5WithPath:path];
    
    NSString * resourceId = [[[NSUUID UUID] UUIDString] lowercaseString];
    
    CBIO::ChatboardFileInterface::insertFileToWhiteBoard([resourceId cStringUsingEncoding:NSUTF8StringEncoding], [name cStringUsingEncoding:NSUTF8StringEncoding], [md5 cStringUsingEncoding:NSUTF8StringEncoding], [path cStringUsingEncoding:NSUTF8StringEncoding], 0, 0, 960, 640);
}

-(void)insertCloudFileToChatboard:(NSString *)resourceId andName:(NSString *)name andMD5:(NSString *)md5 andWidth:(float)width andHeight:(float)height
{
    CBIO::ChatboardFileInterface::insertCloudFileToWhiteBoard([resourceId cStringUsingEncoding:NSUTF8StringEncoding], [name cStringUsingEncoding:NSUTF8StringEncoding], [md5 cStringUsingEncoding:NSUTF8StringEncoding], 0, 0, width, height);
}

- (void)updatePenStyle:(int)penType andColor:(NSString *)color andSize:(int)size
{
    //荧光笔
    if (penType == 1) {
        penType = 0;
        color = [color stringByReplacingOccurrencesOfString:@"#ff" withString:@"#80"];
    }
    std::string   cColor=  [color UTF8String];
    CBIO::ChatboardMenuInterface::updatePenStyle(penType, cColor, size);
}

-(void)updateInputMode:(int)mode
{
    CBIO::InputMode inputMode = CBIO::InputMode::Draw;
    
    switch (mode)
    {
        case 0:
        {
            inputMode = CBIO::InputMode::Draw;
        }
            break;
        case 1:
        {
            inputMode = CBIO::InputMode::Erase;
        }
            break;
        case 2:
        {
            inputMode = CBIO::InputMode::Select;
        }
            break;
        default:
            inputMode = CBIO::InputMode::Draw;
            break;
    }
    
    CBIO::ChatboardMenuInterface::updateInputMode(CBIO::ScreenType::Normal,inputMode);
}

-(void)processUICommand:(int)cmd andParam:(NSString *)param
{
    CBIO::UIBarAction action = CBIO::UIBarAction::Draw;
    
    switch (cmd)
    {
        case 0:
        {
            action = CBIO::UIBarAction::Draw;
        }
            break;
        case 1:
        {
            action = CBIO::UIBarAction::Erase;
        }
            break;
        case 2:
        {
            action = CBIO::UIBarAction::EnterZoom;
        }
            break;
        case 3:
        {
            action = CBIO::UIBarAction::LeaveZoom;
        }
            break;
        case 4:
        {
            action = CBIO::UIBarAction::Rotate;
        }
            break;
        case 5:
        {
            action = CBIO::UIBarAction::Save;
        }
            break;
        case 6:
        {
            action = CBIO::UIBarAction::PageDown;
        }
            break;
        case 7:
        {
            action = CBIO::UIBarAction::PageUp;
        }
            break;
        case 8:
        {
            action = CBIO::UIBarAction::GotoPage;
        }
            break;
        case 9:
        {
            action = CBIO::UIBarAction::WidgetPageDown;
        }
            break;
        case 10:
        {
            action = CBIO::UIBarAction::WidgetPageUp;
        }
            break;
        case 11:
        {
            action = CBIO::UIBarAction::Delete;
        }
            break;
        case 12:
        {
            action = CBIO::UIBarAction::NewPage;
        }
            break;
        case 13:
        {
            action = CBIO::UIBarAction::OnTopicChange;
        }
            break;
        case 14:
        {
            action = CBIO::UIBarAction::EnableVideo;
        }
            break;
        case 15:
        {
            action = CBIO::UIBarAction::DisableVideo;
        }
            break;
        case 16:
        {
            action = CBIO::UIBarAction::CallbackServer;
        }
            break;
        case 17:
        {
            action = CBIO::UIBarAction::ActionStatusMove;
        }
            break;
        case 18:
        {
            action = CBIO::UIBarAction::InsertFirstPage;
        }
            break;
        case 19:
        {
            action = CBIO::UIBarAction::InsertPage;
        }
            break;
        case 20:
        {
            action = CBIO::UIBarAction::RemovePage;
        }
            break;
        default:
            break;
    }
    
    if(param && ![param isEqualToString:@""] && ![param isEqualToString:@"null"] && ![param isKindOfClass:[NSNull class]])
    {
        CBIO::ChatboardMenuInterface::processUICommand(action,[param cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    else
    {
        CBIO::ChatboardMenuInterface::processUICommand(action);
    }
}

-(void)changeZoomNextPosition
{
    CBIO::ChatboardMenuInterface::changeZoomNextPosition();
}

-(void)changeZoomLastPosition
{
    CBIO::ChatboardMenuInterface::changeZoomLastPosition();
}

-(void)changeZoomNewLinePosition
{
    CBIO::ChatboardMenuInterface::changeZoomNewLinePosition();
}

-(void)sendMessageWithMessageData:(NSString *)message
{
    CBIO::ChatboardBusinessInterface::sendChatMessage([_sessionId UTF8String], [message UTF8String]);
}

-(NSString *)getChatListWithRoomId:(NSString *)roomId andMessageId:(NSString *)messageId
{
    if(!messageId || [messageId isEqualToString:@""] || [messageId isEqualToString:@"null"] || [messageId isKindOfClass:[NSNull class]])
    {
        messageId = @"";
    }
    std::string message = CBIO::ChatboardBusinessInterface::getChatMessages([_sessionId UTF8String], [[NSString stringWithFormat:@"%@",roomId] UTF8String], [messageId UTF8String]);
    NSString * messageStr=[NSString stringWithCString:message.c_str() encoding:NSUTF8StringEncoding];
    return messageStr;
}

-(void)sendWhiteBoardPing
{
    CBIO::ChatboardNetworkInterface::sendPing();
}

-(void)joinChatRoomWithChatRoomID:(NSString *)chatRoomId
{
    CBIO::ChatboardBusinessInterface::joinChatRoom([_sessionId UTF8String], [[NSString stringWithFormat:@"%@",chatRoomId] UTF8String]);
}

-(void)leaveChatRoomWithChatRoomId:(NSString *)chatRoomId
{
    CBIO::ChatboardBusinessInterface::leaveChatRoom([_sessionId UTF8String], [[NSString stringWithFormat:@"%@",chatRoomId] UTF8String]);
}

-(void)leaveSingleFullScreen
{
    CBIO::ChatboardMenuInterface::processLeaveFullScreen();
}

-(void)removeVideoWidgetWithTargetId:(NSString *)targetId
{
    CBIO::ChatboardVideoInterface::removeLiveWindow([targetId cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(bool)updateGL:(NSString *)name
{
    return CBIO::ChatboardRenderInterface::draw([name cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(bool)prepareGL:(CBRenderMode)mode
{
    CBIO::ChatboardRenderInterface::initalizeRender(CBIO::RenderType::OpenGLES3);
    
    CBIO::ChatboardRenderInterface::prepareContext();
    
    return true;
}

-(void)closeScreen:(NSString *)name
{
    CBIO::ChatboardRenderInterface::closeScreen([name cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(bool)destroyGL
{
    CBIO::ChatboardRenderInterface::clearRenderer();
    
    return true;
}

-(void)createScreen:(CBScreenMode)mode withName:(NSString *)name withWidth:(int)width andHeight:(int)height
{
    CBIO::ScreenType type;
    switch(mode)
    {
        case CBScreenNormal:
            type = CBIO::ScreenType::Normal;
            break;
        case CBScreenMini:
            type = CBIO::ScreenType::Mini;
            break;
        case CBScreenAssitant:
            type = CBIO::ScreenType::Assistant;
            break;
            
    }
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && type!= CBIO::ScreenType::Assistant)
    {
        type = CBIO::ScreenType::Mini;
    }
    CBIO::ChatboardRenderInterface::createScreen(type, [name cStringUsingEncoding:NSUTF8StringEncoding],width,height);
}

-(void)setIsFilp:(BOOL)isFilp
{
    CBIO::ChatboardRenderInterface::setFilp(isFilp ? true : false);
}

-(void)processTouch:(id)touchInfo andName:(NSString *)name
{
    CBIO::InputEvent _eventType1;
    switch([touchInfo[@"action"] intValue])
    {
        case 0:
            _eventType1 = CBIO::InputEvent::TouchBegin;
            break;
        case 2:
            _eventType1 = CBIO::InputEvent::TouchMove;
            break;
        case 4:
            _eventType1 = CBIO::InputEvent::Stationary;
            return;
        case 1:
            _eventType1 = CBIO::InputEvent::TouchEnd;
            break;
        case 3:
            _eventType1 = CBIO::InputEvent::TouchCancel;
            break;
        default:
            _eventType1 = CBIO::InputEvent::TouchCancel;
            break;
    }
    
    float force = [touchInfo[@"pressure"]doubleValue];
    if([touchInfo[@"tool"] intValue] == 0)
    {
        if(force == 0.0f)
        {
            force = 0.01f;
        }
        
    }
    else
        force = 0.5f;
    
    CBIO::ChatboardRenderInterface::processLocalInput([name cStringUsingEncoding:NSUTF8StringEncoding],[touchInfo[@"tool"] intValue] == 1  ?CBIO::InputSource::Touch : CBIO::InputSource::Stylus,
                                                _eventType1,
                                                [touchInfo[@"pointerId"] intValue],
                                                [touchInfo[@"x"]doubleValue],
                                                [touchInfo[@"y"]doubleValue],
                                                0.5,
                                                [touchInfo[@"eventTime"]longLongValue]);
}

-(void)notifyWhiteBoardLoadTextImageWithID:(NSString *)widgetId andSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andRect:(CGRect)rect andBgColor:(NSString *)bgColor andTargetId:(NSString *)targerId
{
    CBIO::ChatboardFileInterface::notifyWhiteBoardLoadTextImage([widgetId cStringUsingEncoding:NSUTF8StringEncoding], [text cStringUsingEncoding:NSUTF8StringEncoding], [colorString cStringUsingEncoding:NSUTF8StringEncoding],[bgColor cStringUsingEncoding:NSUTF8StringEncoding], size,rect.origin.x, rect.origin.y, rect.size.width, rect.size.height,[targerId cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)notifyTextViewGenImageToWhiteBoardWithSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andBgColor:(NSString *)bgColor andWidgetId:(NSString *)widgetId andTargetId:(NSString *)targetId
{
    
    NSString * string = [NSString stringWithFormat:@"%@\n",text];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    //[paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:[@"我" getStringSizewithStringFont:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} withWidthOrHeight:823 isWidthFixed:YES].height*0.1];  //行间距
    [paragraphStyle setParagraphSpacing:2.0f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:size],
                                 NSForegroundColorAttributeName : [NSString colorWithHexString:colorString],
                                 NSBackgroundColorAttributeName : [NSString colorWithHexString:bgColor],
                                 NSParagraphStyleAttributeName : paragraphStyle};
    
    NSString * md5 = [[NSString stringWithFormat:@"%@%@%@%d",text,colorString,bgColor,size] md5];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",ImageCachePath,md5]])
    {
        UIImage * image = [string imageFromAttributes:attributes size:[string getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES] andMD5:md5 andLineHeight:[@"我" getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES].height];
        
        CBIO::ChatboardFileInterface::notifyWhiteBoardLoadTextImage([widgetId cStringUsingEncoding:NSUTF8StringEncoding], [text cStringUsingEncoding:NSUTF8StringEncoding], [colorString cStringUsingEncoding:NSUTF8StringEncoding],[bgColor cStringUsingEncoding:NSUTF8StringEncoding],size, 0, 0, image.size.width, image.size.height,[targetId cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

-(void)insertTextViewToWhiteBoardWithSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andBgColor:(NSString *)bgColor
{
    NSString * string = [NSString stringWithFormat:@"%@\n",text];
    
    NSString * resourceId = [[[NSUUID UUID] UUIDString] lowercaseString];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    //[paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:[@"我" getStringSizewithStringFont:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} withWidthOrHeight:823 isWidthFixed:YES].height*0.1];  //行间距
    [paragraphStyle setParagraphSpacing:2.0f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:size],
                                 NSForegroundColorAttributeName : [NSString colorWithHexString:colorString],
                                 NSBackgroundColorAttributeName : [NSString colorWithHexString:bgColor],
                                 NSParagraphStyleAttributeName : paragraphStyle};
    
    NSString * md5 = [[NSString stringWithFormat:@"%@%@%@%d",text,colorString,bgColor,size] md5];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",ImageCachePath,md5]])
    {
        UIImage * image = [string imageFromAttributes:attributes size:[string getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES] andMD5:md5 andLineHeight:[@"我" getStringSizewithStringFont:attributes withWidthOrHeight:823 isWidthFixed:YES].height];
        
        CBIO::ChatboardFileInterface::insertTextViewToWhiteBoard([resourceId cStringUsingEncoding:NSUTF8StringEncoding], [text cStringUsingEncoding:NSUTF8StringEncoding], [colorString cStringUsingEncoding:NSUTF8StringEncoding],[bgColor cStringUsingEncoding:NSUTF8StringEncoding], size,0, 0, image.size.width, image.size.height);
    }
}

-(void)deleteTextWidgetWithID:(NSString *)guid  andTargetId:(NSString *)targetId
{
    CBIO::ChatboardFileInterface::processDeleteText(CBIO::UIBarAction::Delete,[guid cStringUsingEncoding:NSUTF8StringEncoding],[targetId cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)enterZoomMode
{
    CBIO::ChatboardMenuInterface::processUICommand(CBIO::UIBarAction::EnterZoom);
    CBIO::ChatboardMenuInterface::updateInputMode(CBIO::ScreenType::Normal, CBIO::InputMode::Draw);
}

-(void)leaveZoomMode
{
    CBIO::ChatboardMenuInterface::processUICommand(CBIO::UIBarAction::LeaveZoom);
    CBIO::ChatboardMenuInterface::updateInputMode(CBIO::ScreenType::Normal, CBIO::InputMode::Draw);
}

-(void)setScreenTypeWithIdentifier:(NSString *)identifier andScreenMode:(CBScreenMode)mode
{
    CBIO::ScreenType type;
    switch(mode)
    {
        case CBScreenNormal:
            type = CBIO::ScreenType::Normal;
            break;
        case CBScreenMini:
            type = CBIO::ScreenType::Mini;
            break;
        case CBScreenAssitant:
            type = CBIO::ScreenType::Assistant;
            break;
            
    }
    CBIO::ChatboardRenderInterface::setScreenType([identifier cStringUsingEncoding:NSUTF8StringEncoding], type);
}

-(void)updateSizeWithWidth:(int)width andHeight:(int)height andName:(NSString *)name
{
    CBIO::ChatboardRenderInterface::updateScreenSize([name cStringUsingEncoding:NSUTF8StringEncoding], width, height);
}

@end
