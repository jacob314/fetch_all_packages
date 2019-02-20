//
//  MCService.h
//  native_service
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import "MessageDispatcher.h"

@protocol FlutterNativeService <NSObject>
@required
- (NSString *)serviceName;
- (NSString *)methodChannelName;
- (NSString *)eventChannelName;

- (void)invoke:(NSString *)name args:(NSDictionary *)args result:(MCMessageResult)result;
- (void)registerHandler:(id<MessageHandler>)handler;

- (void)didRecieveEventSink:(void (^)(id))eventSink arguments:(id)arguments;
- (void)didCancleEvent:(id)arguments;
- (void)emitEvent:(NSDictionary *)obj;
- (void)start;
- (void)end;
@end
