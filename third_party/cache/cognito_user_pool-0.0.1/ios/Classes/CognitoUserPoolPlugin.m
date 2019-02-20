#import "CognitoUserPoolPlugin.h"
#import <cognito_user_pool/cognito_user_pool-Swift.h>

@implementation CognitoUserPoolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCognitoUserPoolPlugin registerWithRegistrar:registrar];
}
@end
