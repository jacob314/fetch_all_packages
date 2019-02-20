#import "FillablePdfFormPlugin.h"
#import <fillable_pdf_form/fillable_pdf_form-Swift.h>

@implementation FillablePdfFormPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFillablePdfFormPlugin registerWithRegistrar:registrar];
}
@end
