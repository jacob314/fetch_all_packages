#import "WhiteBoardFlutterPlugin.h"
#import "ChatboardInterface.h"
#import "CBBaseRender.h"

@interface WhiteBoardFlutterPlugin()

@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textures;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, CBBaseRender *> *renders;

@property (nonatomic, strong) FlutterMethodChannel * channel;

@end

@implementation WhiteBoardFlutterPlugin

+ (WhiteBoardFlutterPlugin *)sharedWhiteBoardFlutterPluginlManager
{
    static WhiteBoardFlutterPlugin * formatInstanceModelManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^(){
        formatInstanceModelManager = [[WhiteBoardFlutterPlugin alloc] init];
    });
    return formatInstanceModelManager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"white_board_flutter"
            binaryMessenger:[registrar messenger]];
    
    [[ChatboardInterface sharedChatboardInterfaceManager] initializeChatBoard];
    
    WhiteBoardFlutterPlugin* instance = [WhiteBoardFlutterPlugin sharedWhiteBoardFlutterPluginlManager];
    instance.textures = [registrar textures];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)callMethod:(NSString *)method andParams:(id)params
{
    [_channel invokeMethod:method arguments:params];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSLog(@"方法名称：%@    参数：%@",call.method,call.arguments);
    
    if(!_renders)
    {
        _renders = [NSMutableDictionary dictionary];
    }
    
    //创建渲染器
    if([call.method isEqualToString:@"create"])
    {
        NSNumber *width = [NSNumber numberWithInt:[call.arguments[@"width"]intValue]];
        NSNumber *height = [NSNumber numberWithInt:[call.arguments[@"height"]intValue]];
        
        
        
        NSInteger __block textureId;
        id<FlutterTextureRegistry> __weak registry = self.textures;

        CBScreenMode mode;
        NSString * name = nil;
        NSNumber *modeInt = [NSNumber numberWithInt:[call.arguments[@"type"]intValue]];
        switch (modeInt.intValue) {
            case 0:
            {
                mode = CBScreenNormal;
                name = @"main";
            }
                break;
            case 1:
            {
                mode = CBScreenMini;
                name = @"main";
            }
                break;
            case 2:
            {
                mode = CBScreenAssitant;
                name = @"assitant";
            }
                break;
            default:
            {
                mode = CBScreenNormal;
                name = @"main";
            }
                break;
        }
        CBBaseRender *baseRender = [[CBBaseRender alloc] initWithSize:CGSizeMake([width floatValue], [height floatValue])
                                                        andScreenMode:mode
                                                              andName:name
                                                           onNewFrame:^{
                                                               [registry textureFrameAvailable:textureId];
                                                           }];
        
        textureId = [self.textures registerTexture:baseRender];
        self.renders[@(textureId)] = baseRender;
        result(@(textureId));
        return;
    }
    
    //改变白板类型
    if([call.method isEqualToString:@"changeBoardType"])
    {
        CBBaseRender * render = [self.renders objectForKey:[NSNumber numberWithInt:[call.arguments[@"textureId"] intValue]]];
        if(render)
        {
            CBScreenMode mode;
            switch([call.arguments[@"type"] intValue])
            {
                case 0:
                {
                    mode = CBScreenNormal;
                }
                    break;
                case 1:
                {
                    mode = CBScreenMini;
                }
                    break;
                case 2:
                {
                    mode = CBScreenAssitant;
                }
                    break;
                default:
                {
                    mode = CBScreenNormal;
                }
                    break;
            }
            
            [[ChatboardInterface sharedChatboardInterfaceManager] setScreenTypeWithIdentifier:[render identify] andScreenMode:mode];
        }
        result(nil);
        return;
    }
    
    //更新屏幕大小
    if([call.method isEqualToString:@"update"])
    {
        CBBaseRender * render = [self.renders objectForKey:[NSNumber numberWithInt:[call.arguments[@"textureId"] intValue]]];
        if(render)
        {
            [[ChatboardInterface sharedChatboardInterfaceManager] updateSizeWithWidth:[call.arguments[@"width"] intValue] andHeight:[call.arguments[@"height"] intValue] andName:[render identify]];
        }
        result(nil);
        return;
    }
    
    //关闭屏幕
    if([call.method isEqualToString:@"close"])
    {
        CBBaseRender * render = [self.renders objectForKey:[NSNumber numberWithInt:[call.arguments[@"textureId"] intValue]]];
        if(render)
        {
            [render removeFromSuperview];
        }
        result(nil);
        return;
    }
    
    //touch事件
    if([call.method isEqualToString:@"touch"])
    {
        CBBaseRender * render = [self.renders objectForKey:[NSNumber numberWithInt:[call.arguments[@"textureId"] intValue]]];
        if(render)
        {
            [[ChatboardInterface sharedChatboardInterfaceManager] processTouch:call.arguments andName:[render identify]];
        }
        result(nil);
        return;
    }
    
    //添加服务器配置
    if([call.method isEqualToString:@"addServerConfig"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] addServerInfo:call.arguments[@"name"] serverAddress:call.arguments[@"host"] serverPort:call.arguments[@"port"] protocol:call.arguments[@"protocol"]];
        result(nil);
        return;
    }
    
    //登录白板
    if([call.method isEqualToString:@"login"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] loginChatBoard:call.arguments[@"accountId"] andSessionId:call.arguments[@"sessionId"]];
        result(nil);
        return;
    }
    
    //登出白板
    if([call.method isEqualToString:@"logout"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] logouChatBoard];
        result(nil);
        return;
    }
    
    //加入白板房间
    if([call.method isEqualToString:@"joinRoom"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] enterTopic:call.arguments[@"roomId"]];
        result(nil);
        return;
    }
    
    //离开白板房间
    if([call.method isEqualToString:@"leaveRoom"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] leaveTopic:call.arguments[@"roomId"]];
        result(nil);
        return;
    }
    
    //设置放大镜倍数
    if([call.method isEqualToString:@"setMagnifyScale"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] setMagnifyScale:[call.arguments[@"scale"] floatValue]];
        result(nil);
        return;
    }
    
    //获取放大镜倍数
    if([call.method isEqualToString:@"getMagnifyScale"])
    {
        float scale = [[ChatboardInterface sharedChatboardInterfaceManager] getMagnifyScale];
        result(@(scale));
        return;
    }
    
    //白板插入文件
    if([call.method isEqualToString:@"insertFile"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] insertFileToChatBoard:call.arguments[@"path"]];
        result(nil);
        return;
    }
    
    //白板插入云盘文件
    if([call.method isEqualToString:@"insertCloudFile"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] insertCloudFileToChatboard:call.arguments[@"resId"] andName:call.arguments[@"name"] andMD5:call.arguments[@"md5"] andWidth:[call.arguments[@"width"] floatValue] andHeight:[call.arguments[@"height"] floatValue]];
        result(nil);
        return;
    }
    
    //更新笔的样式
    if([call.method isEqualToString:@"updatePenStyle"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] updatePenStyle:[call.arguments[@"type"] intValue] andColor:call.arguments[@"color"] andSize:[call.arguments[@"size"] intValue]];
        result(nil);
        return;
    }
    
    //更新输入模式
    if([call.method isEqualToString:@"updateInputMode"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] updateInputMode:[call.arguments[@"mode"] intValue]];
        result(nil);
        return;
    }
    
    //白板的命令
    if([call.method isEqualToString:@"boardCommand"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] processUICommand:[call.arguments[@"command"] intValue] andParam:call.arguments[@"param"]];
        result(nil);
        return;
    }
    
    //打开放大镜
    if([call.method isEqualToString:@"openMagnifier"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] enterZoomMode];
        result(nil);
        return;
    }
    
    //关闭放大镜
    if([call.method isEqualToString:@"closeMagnifier"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] leaveZoomMode];
        result(nil);
        return;
    }
    
    //放大镜光标移到下一个位置
    if([call.method isEqualToString:@"zoomMoveNext"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] changeZoomNextPosition];
        result(nil);
        return;
    }
    
    //放大镜光标移到上一个位置
    if([call.method isEqualToString:@"zoomMoveLast"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] changeZoomLastPosition];
        result(nil);
        return;
    }
    
    //放大镜光标移到下一行
    if([call.method isEqualToString:@"zoomMoveNewLine"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] changeZoomNewLinePosition];
        result(nil);
        return;
    }
    
    //发送聊天消息
    if([call.method isEqualToString:@"sendChatMessage"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] sendMessageWithMessageData:call.arguments[@"message"]];
        result(nil);
        return;
    }
    
    //获取聊天消息
    if([call.method isEqualToString:@"getChatMessages"])
    {
        NSString * message = [[ChatboardInterface sharedChatboardInterfaceManager] getChatListWithRoomId:call.arguments[@"roomId"] andMessageId:call.arguments[@"messageId"]];
        result(message);
        result(nil);
        return;
    }
    
    //发送ping
    if([call.method isEqualToString:@"sendPing"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] sendWhiteBoardPing];
        result(nil);
        return;
    }
    
    //加入聊天房间
    if([call.method isEqualToString:@"joinChatRoom"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] joinChatRoomWithChatRoomID:call.arguments[@"roomId"]];
        result(nil);
        return;
    }
    
    //退出聊天房间
    if([call.method isEqualToString:@"leaveChatRoom"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] leaveChatRoomWithChatRoomId:call.arguments[@"roomId"]];
        result(nil);
        return;
    }
    
    //离开全屏模式
    if([call.method isEqualToString:@"leaveFullScreen"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] leaveSingleFullScreen];
        result(nil);
        return;
    }
    
    //插入文本
    if([call.method isEqualToString:@"insertText"])
    {
        NSString * _id = call.arguments[@"id"];
        if(!_id || [_id isEqualToString:@""] || [_id isEqualToString:@"null"] || [_id isKindOfClass:[NSNull class]])
        {
            [[ChatboardInterface sharedChatboardInterfaceManager] insertTextViewToWhiteBoardWithSize:[call.arguments[@"size"] intValue] andColor:call.arguments[@"color"] andText:call.arguments[@"text"] andBgColor:call.arguments[@"backgroundColor"]];
        }
        else
        {
            [[ChatboardInterface sharedChatboardInterfaceManager] notifyTextViewGenImageToWhiteBoardWithSize:[call.arguments[@"size"] intValue] andColor:call.arguments[@"color"] andText:call.arguments[@"text"] andBgColor:call.arguments[@"backgroundColor"] andWidgetId:call.arguments[@"id"] andTargetId:call.arguments[@"targetId"]];
        }
        result(nil);
        return;
    }
    
    //删除文本
    if([call.method isEqualToString:@"deleteText"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] deleteTextWidgetWithID:call.arguments[@"id"] andTargetId:call.arguments[@"targetId"]];
        result(nil);
        return;
    }
    
    //截图
    if([call.method isEqualToString:@"screenshots"])
    {
        CBBaseRender * render = nil;
        
        for(NSNumber * num in [self.renders allKeys])
        {
            CBBaseRender * rr = [[self renders] objectForKey:num];
            if([[rr identify] isEqualToString:@"main"])
            {
                render = rr;
                break;
            }
        }
        if(render)
        {
            NSString * path = [render screenshot];
            result(path);
        }
        else
        {
            result(@"");
        }
        return;
    }
    
    //删除视频窗口
    if([call.method isEqualToString:@"removeLiveVideo"])
    {
        [[ChatboardInterface sharedChatboardInterfaceManager] removeVideoWidgetWithTargetId:call.arguments[@"videoId"]];
        result(nil);
        return;
    }
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
