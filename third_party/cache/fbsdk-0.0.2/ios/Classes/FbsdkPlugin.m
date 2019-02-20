#import "FbsdkPlugin.h"
#import "FacebookLoginKit.h"
#import "FacebookShareKit.h"

@implementation FbsdkPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [FacebookLoginKit registerWithRegistrar:registrar];
    [FacebookShareKit registerWithRegistrar:registrar];
}

@end
