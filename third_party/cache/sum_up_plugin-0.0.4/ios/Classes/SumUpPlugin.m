#import "SumUpPlugin.h"
#import <sum_up_plugin/sum_up_plugin-Swift.h>
#import <Flutter/Flutter.h>

static NSString *const ksMyAffiliateKey = @"my_affiliate_key";


@implementation SumUpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSumUpPlugin registerWithRegistrar:registrar];

}
@end
