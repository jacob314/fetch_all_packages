#import "AwareframeworkSignificantmotionPlugin.h"
#import <awareframework_significantmotion/awareframework_significantmotion-Swift.h>

@implementation AwareframeworkSignificantmotionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkSignificantmotionPlugin registerWithRegistrar:registrar];
}
@end
