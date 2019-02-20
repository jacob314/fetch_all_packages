#import "RazorpayCheckoutPlugin.h"
#import <razorpay_checkout/razorpay_checkout-Swift.h>

@implementation RazorpayCheckoutPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRazorpayCheckoutPlugin registerWithRegistrar:registrar];
}
@end
