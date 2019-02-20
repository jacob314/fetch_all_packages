#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBSDKLoginManagerLoginResult(Extensions)
- (NSObject *)parseLoginResult;
@end
