#import "NSObject+FBSDKSharingContent.h"

@implementation NSObject(FBSDKSharingContent)

+ (id<FBSDKSharingContent>)convertFromDictionary:(NSDictionary *)dictionary {
    NSString *contentType = [dictionary objectForKey:@"contentType"];
    id<FBSDKSharingContent> content = nil;
    
    if ([contentType isEqualToString:@"link"]) {
        content = [self buildLinkContent:dictionary];
    } else if ([contentType isEqualToString:@"photo"]) {
        content = [self buildPhotoContent:dictionary];
    } else if ([contentType isEqualToString:@"video"]) {
        content = [self buildLinkContent:dictionary];
    } else if ([contentType isEqualToString:@"open-graph"]) {
        content = [self buildLinkContent:dictionary];
    } else {
        return nil;
    }
    return content;
}

- (FBSDKShareLinkContent *)buildLinkContent:(NSDictionary *)dictionary {
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentURL = [NSURL URLWithString:dictionary[@"contentUrl"]];
    linkContent.quote = dictionary[@"quote"];
    return linkContent;
}

- (FBSDKSharePhotoContent *)buildPhotoContent:(NSDictionary *)dictionary {
    NSArray *photoData = dictionary[@"photos"];
    FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    // Generate an FBSDKSharePhoto for each item in photoData
    for (NSDictionary *p in photoData) {
        NSURL *imageURL = [NSURL URLWithString:p[@"imageUrl"]];
        BOOL userGenerated = p[@"userGenerated"];
        FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImageURL:imageURL userGenerated:userGenerated];
        photo.caption = p[@"caption"];
        if (photo.image) {
            [photos addObject:photo];
        }
    }
    photoContent.photos = photos;
    photoContent.contentURL = [NSURL URLWithString:dictionary[@"contentUrl"]];
    return photoContent;
}
@end
