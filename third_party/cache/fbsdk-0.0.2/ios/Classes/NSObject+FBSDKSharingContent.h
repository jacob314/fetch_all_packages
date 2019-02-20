#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface NSObject(FBSDKSharingContent)
+ (id<FBSDKSharingContent>)convertFromDictionary:(NSDictionary *)dictionary;
@end
