//
//  PhotoCache.h
//  CTAssetsPickerController
//
//  Created by panda on 2018/11/19.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCache : NSObject

+ (PhotoCache *)manager;
- (void)savePhotos:(NSArray *)assets
              mode:(PHImageContentMode)contentMode
        completion:(void(^)(NSArray * photoUrls))completion;

- (NSString *)saveToTmpDir:(UIImage *)image type:(NSString *)type;
- (UIImage *)resizeToSquare:(float)side image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
