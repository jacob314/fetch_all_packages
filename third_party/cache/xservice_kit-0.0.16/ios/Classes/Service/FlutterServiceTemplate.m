//
//  FlutterServiceTemplate.m
//  native_service
//
//  Created by Jidong Chen on 2018/9/6.
//

#import "FlutterServiceTemplate.h"
#import "FlutterServiceCallDispather.h"
#import <xservice_kit/MessengerFacede.h>
#import "XKCollectionHelper.h"

@interface FlutterServiceTemplate()
@property (nonatomic,copy) void (^eventSink)(id);
@property (nonatomic,strong) NSDictionary *eventArguments;
@property (nonatomic,strong) id<MessageDispatcher> msgDispatcher;
@end

@implementation FlutterServiceTemplate

- (instancetype)init
{
    if (self = [super init]) {
        _msgDispatcher = [FlutterServiceCallDispather new];
        _msgDispatcher.context = self;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [self init]) {
        _name = name;
    }
    
    return self;
}

- (NSString *)serviceName
{
    return _name;
}

- (NSString *)methodChannelName
{
    return [self.serviceName stringByAppendingString:@"_method_channel"];
}

- (NSString *)eventChannelName
{
   return [self.serviceName stringByAppendingString:@"_event_channel"];
}

- (void)didRecieveEventSink:(void (^)(id))eventSink arguments:(id)arguments
{
    _eventSink = eventSink;
    _eventArguments = arguments;
}

- (void)didCancleEvent:(id)arguments
{
    _eventSink = nil;
    _eventArguments = nil;
}

- (void)emitEvent:(NSDictionary *)obj
{
#if DEBUG
    if (![obj isKindOfClass: NSDictionary.class]) {
        [NSException raise:@"Invalid argument exception!"
                    format:@"Only NSDictionary is allowed. Crash in debug mode!"];
        return;
    }
#endif
    
    if (_eventSink) {
        _eventSink([self checkType:obj]);
    }
}

- (BOOL)isSupportedType:(id)value
{
    if(!value) return NO;
    
    NSArray *const supportedType = @[NSNumber.class,
                                     NSString.class,
                                     NSArray.class,
                                     NSDictionary.class];
    
    for(Class clazz in supportedType){
        if([value isKindOfClass:clazz]){
            return YES;
        }
    }
    
#if DEBUG
    [NSException raise:NSInvalidArgumentException
                format:@"unsported type! Crash in debug!"];
#endif
    
    return NO;
}

- (NSDictionary *)checkType:(NSDictionary *)param
{
    NSDictionary *checkedParam = [XKCollectionHelper deepCopyNSDictionary:param filter:^bool (id  _Nonnull value) {
        return [self isSupportedType:value];
    }];
  
    return checkedParam;
}

- (void)start
{
    [[MessengerFacede sharedInstance] registerMethodChannelWithName:self.methodChannelName
                                                           callback:^(id result) {}];
    
    [[MessengerFacede sharedInstance] registerEventChannelWithName:self.eventChannelName
                                                           callback:^(id result) {}];
    
    if ([self respondsToSelector: @selector(handlers)]) {
        NSArray *handlers = [self performSelector:@selector(handlers)];
        for(id<MessageHandler> h in handlers){
            [_msgDispatcher registerHandler:h];
        }
    }
    
    [[MessengerFacede sharedInstance] setMessageHandler:^(id<MCMessage> msg, MCMessageResult result) {
        [_msgDispatcher dispatch:msg result:result];
    } forMethodChannel:self.methodChannelName];
    
    
    [[MessengerFacede sharedInstance] setStreamHandler:^(id<MCHost> host,
                                                         MCMessageStreamEvent event,
                                                         id arguments,
                                                         MCStreamEventSink sink) {
        switch (event) {
            case MCMessageStreamEventOnListen:
                [self didRecieveEventSink:sink arguments:arguments];
                break;
            case MCMessageStreamEventOnCancel:
                [self didCancleEvent:arguments];
                break;
        }
    } forEventChannel:self.eventChannelName];
        
}

- (void)invoke:(NSString *)name args:(NSDictionary *)args result:(MCMessageResult)result
{
    [[MessengerFacede sharedInstance] sendMessage:name
                                             args:args
                                          channel:self.methodChannelName
                                           result:result];
}

- (void)registerHandler:(id<MessageHandler>)handler
{
    [_msgDispatcher registerHandler:handler];
}

- (void)end
{
    [[MessengerFacede sharedInstance] setMessageHandler:nil forMethodChannel:self.methodChannelName];
    [[MessengerFacede sharedInstance] setStreamHandler:nil forEventChannel:self.eventChannelName];
    self.msgDispatcher = nil;
}

@end
