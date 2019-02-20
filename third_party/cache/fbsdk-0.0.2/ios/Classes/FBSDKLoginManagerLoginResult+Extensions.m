#import "FBSDKLoginManagerLoginResult+Extensions.h"

@implementation FBSDKLoginManagerLoginResult(Extensions)

- (NSObject *)parseLoginResult {
    FBSDKAccessToken *token = self.token;
    if (!token) {
        return @{@"token": [NSNull null], @"isCancelled": @(self.isCancelled)};
    }
    return @{
             @"token":
                 @{
                     @"tokenString": token.tokenString,
                     @"userId": token.userID,
                     @"refreshDate": token.refreshDate.description,
                     @"expirationDate": token.expirationDate.description,
                     @"permissions": [token.permissions allObjects],
                     @"declinedPermissions": [token.declinedPermissions allObjects]
                     },
             @"isCancelled": @(self.isCancelled),
             @"grantedPermissions": [self.grantedPermissions allObjects],
             @"declinedPermissions": [self.declinedPermissions allObjects]
             };
}

@end
