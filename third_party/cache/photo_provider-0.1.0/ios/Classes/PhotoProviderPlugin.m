#import "PhotoProviderPlugin.h"
#import <photo_provider/photo_provider-Swift.h>

@implementation PhotoProviderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhotoProviderPlugin registerWithRegistrar:registrar];
}
@end
