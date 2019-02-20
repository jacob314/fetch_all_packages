#import "MultiImagePickerPlugin.h"
#import <custom_multi_image_picker/custom_multi_image_picker-Swift.h>

@implementation MultiImagePickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMultiImagePickerPlugin registerWithRegistrar:registrar];
}
@end
