//
//  ChatboardInterface.h
//  Pods-Runner
//
//  Created by 陈凯 on 2018/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CBRenderMode)
{
    CBRenderOpenGL,
    CBRenderOpenGLES2,
    CBRenderOpenGLES3
};
typedef NS_ENUM(NSInteger,CBScreenMode)
{
    CBScreenNormal,
    CBScreenMini,
    CBScreenAssitant
};
typedef NS_ENUM(NSInteger,CBTouchEventMode)
{
    CBTouchEventBegin,
    CBTouchEventEnd,
    CBTouchEventMove,
    CBTouchEventCancel
};

@interface ChatboardInterface : NSObject

@property(nonatomic,strong)NSString * accountId;

@property(nonatomic,strong)NSString * sessionId;

/**
 单利

 @return 单利对象
 */
+ (ChatboardInterface *)sharedChatboardInterfaceManager;

/**
 初始化白板

 @return 结果
 */
-(BOOL)initializeChatBoard;

/**
 添加服务器配置

 @param name 名称
 @param address 地址
 @param port 端口
 @param protocol 协议
 */
-(void)addServerInfo:(NSString *)name serverAddress:(NSString *)address serverPort:(NSString *)port protocol:(NSString *)protocol;

/**
登录白板

 @param accountId accountId
 @param sessionId sessionId
 */
-(void)loginChatBoard:(NSString *)accountId andSessionId:(NSString *)sessionId;

/**
 登出白板
 */
-(void)logouChatBoard;

/**
 加入白板房间

 @param topicId 房间id
 */
-(void)enterTopic:(NSString * )topicId;


/**
 离开白板房间

 @param topicId 房间ID
 */
-(void)leaveTopic:(NSString *)topicId;

/**
 设置放大镜倍数

 @param scale 放大镜倍数
 */
-(void)setMagnifyScale:(float)scale;

/**
 获取放大镜倍数

 @return 放大镜倍数
 */
-(float)getMagnifyScale;

/**
 白板插入文件

 @param path 路劲
 */
-(void)insertFileToChatBoard:(NSString *)path;

/**
 白板插入云盘文件

 @param resourceId ID
 @param name 名称
 @param md5 MD5
 @param width 宽
 @param height 高
 */
-(void)insertCloudFileToChatboard:(NSString *)resourceId andName:(NSString *)name andMD5:(NSString *)md5 andWidth:(float)width andHeight:(float)height;

/**
 更新笔的样式

 @param penType 笔类型
 @param color 颜色
 @param size 大小
 */
- (void)updatePenStyle:(int)penType andColor:(NSString *)color andSize:(int)size;

/**
更新输入模式

 @param mode 模式
 */
-(void)updateInputMode:(int)mode;

/**
 白板命令

 @param cmd 命令
 @param param 参数
 */
-(void)processUICommand:(int)cmd andParam:(NSString *)param;

/**
 放大镜下一个位置
 */
-(void)changeZoomNextPosition;

/**
 放大镜上一个位置
 */
-(void)changeZoomLastPosition;

/**
 放大镜下一行
 */
-(void)changeZoomNewLinePosition;

/**
 发送聊天消息

 @param message 消息
 */
-(void)sendMessageWithMessageData:(NSString *)message;

/**
 获取聊天消息

 @param roomId 房间id
 @param messageId 消息id
 @return 聊天消息
 */
-(NSString *)getChatListWithRoomId:(NSString *)roomId andMessageId:(NSString *)messageId;

/**
 发送ping消息
 */
-(void)sendWhiteBoardPing;

/**
 加入聊天房间

 @param chatRoomId 房间id
 */
-(void)joinChatRoomWithChatRoomID:(NSString *)chatRoomId;

/**
 退出聊天房间

 @param chatRoomId 房间ID
 */
-(void)leaveChatRoomWithChatRoomId:(NSString *)chatRoomId;

/**
 退出全屏模式
 */
-(void)leaveSingleFullScreen;

/**
 删除视频

 @param targetId 视频id
 */
-(void)removeVideoWidgetWithTargetId:(NSString *)targetId;

/**
 更新GL

 @param name 名称
 @return 结果
 */
-(bool)updateGL:(NSString *)name;

/**
 初始化GL

 @param mode 模式
 @return 结果
 */
-(bool)prepareGL:(CBRenderMode)mode;

/**
 关闭屏幕

 @param name 屏幕标识
 */
-(void)closeScreen:(NSString *)name;

/**
 退出销毁环境

 @return 结果
 */
-(bool)destroyGL;

/**
 创建屏幕

 @param mode 屏幕类型
 @param name 标识
 @param width 宽
 @param height 高
 */
-(void)createScreen:(CBScreenMode)mode withName:(NSString *)name withWidth:(int)width andHeight:(int)height;

/**
 touch事件

 @param touchInfo info
 */
-(void)processTouch:(id)touchInfo andName:(NSString *)name;

/**
 设置翻转

 @param isFilp 翻转
 */
-(void)setIsFilp:(BOOL)isFilp;

/**
 更新文本通知

 @param widgetId ID
 @param size 字体大小
 @param colorString 颜色
 @param text 文本
 @param rect frame
 @param bgColor 背景色
 @param targerId targerId
 */
-(void)notifyWhiteBoardLoadTextImageWithID:(NSString *)widgetId andSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andRect:(CGRect)rect andBgColor:(NSString *)bgColor andTargetId:(NSString *)targerId;

/**
 插入文本

 @param size size description
 @param colorString colorString description
 @param text text description
 @param bgColor bgColor description
 */
-(void)insertTextViewToWhiteBoardWithSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andBgColor:(NSString *)bgColor;

/**
 文字生成图片并通知白板

 @param size size description
 @param colorString colorString description
 @param text text description
 @param bgColor bgColor description
 @param widgetId widgetId description
 @param targetId targetId description
 */
-(void)notifyTextViewGenImageToWhiteBoardWithSize:(int)size andColor:(NSString *)colorString andText:(NSString *)text andBgColor:(NSString *)bgColor andWidgetId:(NSString *)widgetId andTargetId:(NSString *)targetId;

/**
 删除文本

 @param guid guid description
 @param targetId targetId description
 */
-(void)deleteTextWidgetWithID:(NSString *)guid  andTargetId:(NSString *)targetId;

/**
 进入放大镜
 */
-(void)enterZoomMode;

/**
 退出放大镜
 */
-(void)leaveZoomMode;

/**
改变白板屏幕类型

 @param identifier 标识
 @param mode 类型
 */
-(void)setScreenTypeWithIdentifier:(NSString *)identifier andScreenMode:(CBScreenMode)mode;

/**
 更新渲染器大小

 @param width width description
 @param height height description
 @param name name description
 */
-(void)updateSizeWithWidth:(int)width andHeight:(int)height andName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
