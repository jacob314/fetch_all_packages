//
//  VoiceRecognitionView.h
//  Pods-Runner
//
//  Created by mac on 2018/12/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "ATAudioVisualizer.h"
NS_ASSUME_NONNULL_BEGIN

@interface VoiceRecognitionView : NSObject<FlutterPlatformView>
- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

@interface VoiceRecognitionFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
