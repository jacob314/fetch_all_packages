#import "VoiceRecognitionPlugin.h"
#import "VoiceRecognitionView.h"
@implementation VoiceRecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    VoiceRecognitionFactory* voiceFactory =
    [[VoiceRecognitionFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:voiceFactory withId:@"voice_recognition"];
}
@end
