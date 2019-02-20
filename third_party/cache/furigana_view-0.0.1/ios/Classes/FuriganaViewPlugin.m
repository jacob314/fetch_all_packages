#import "FuriganaViewPlugin.h"
#import <furigana_view/furigana_view-Swift.h>

@implementation FuriganaViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFuriganaViewPlugin registerWithRegistrar:registrar];
}
@end
