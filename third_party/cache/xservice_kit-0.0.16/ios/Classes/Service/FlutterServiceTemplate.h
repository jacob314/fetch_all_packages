//
//  FlutterServiceTemplate.h
//  native_service
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import "FlutterNativeService.h"

@interface FlutterServiceTemplate : NSObject<FlutterNativeService>

@property (nonatomic,copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;

//This template provides default implementation of these method. You don't have implement these by yourself normally.
- (void)didRecieveEventSink:(void (^)(id))eventSink arguments:(id)arguments;
- (void)didCancleEvent:(id)arguments;
- (void)emitEvent:(NSDictionary *)obj;

- (void)start;
- (void)end;
@end
