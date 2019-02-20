//
//  CBBaseRender.h
//  Pods-Runner
//
//  Created by xuxinyuan on 2018/11/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "ChatboardInterface.h"

@interface CBBaseRender : NSObject<FlutterTexture>
{
    NSString * _name;
    EAGLContext *context;
}
-(instancetype)initWithSize:(CGSize)size andScreenMode:(CBScreenMode)mode andName:(NSString *)name onNewFrame:(void(^)(void))onNewFrame;

-(NSString *)identify;

- (void)removeFromSuperview;

-(NSString *)screenshot;

@end
