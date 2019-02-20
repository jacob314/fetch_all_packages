#import "FlutterYoutubeExtractorPlugin.h"
#import <flutter_youtube_extractor/flutter_youtube_extractor-Swift.h>

@implementation FlutterYoutubeExtractorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterYoutubeExtractorPlugin registerWithRegistrar:registrar];
}
@end
