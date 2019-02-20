#import "RazorpayPlugin.h"
#import <razorpay/razorpay-Swift.h>

@implementation RazorpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRazorpayPlugin registerWithRegistrar:registrar];
}
@end
