//
//  PhotoCache.m
//  CTAssetsPickerController
//
//  Created by panda on 2018/11/19.
//

#import "PhotoCache.h"

@interface PhotoCache ()

@property(nonatomic, copy) NSMutableArray * photoList;

@end

@implementation PhotoCache

+ (PhotoCache *)manager {
    PhotoCache * manager = [[PhotoCache alloc] init];
    return manager;
}

- (void)savePhotos:(NSArray *)assets
              mode:(PHImageContentMode)contentMode
        completion:(void(^)(NSArray * photoUrls))completion{
    
    // 移动到 tmp 文件目录下，生成 原片/缩略图 各一份
    NSMutableArray * paths = @[].mutableCopy;
    
    // 从资源库获取图片
    for (PHAsset * asset in assets) {
        __block NSMutableDictionary *dict = @{}.mutableCopy;
        
        [self accessToImageAccordingToTheAsset:asset size:CGSizeMake(2048, 2048) contentMode:contentMode completion:^(UIImage *image, NSDictionary *info) {
            
            NSString * path = [self saveToTmpDir:image type:@"i"];
            dict[@"i"] = path;
        }];
        
        [self accessToImageAccordingToTheAsset:asset size:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill completion:^(UIImage *image, NSDictionary *info) {
            NSString * path = [self saveToTmpDir:image type:@"t"];
            dict[@"t"] = path;
        }];
        
        [paths addObject:dict];
    }
    completion(paths);
}

- (NSString *)saveToTmpDir:(UIImage *)image type:(NSString *)type{
    // 如果长或者宽大于 2048 则先压缩尺寸
    if (image.size.width > 2048 || image.size.height > 2048) {
        float ratio = image.size.width/image.size.height;
        CGSize size = ratio > 1.f ? CGSizeMake(2048, 2048 / ratio) : CGSizeMake(2048 * ratio, 2048);
        
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *tmpFile = [NSString stringWithFormat:@"%@_%@.jpg", [type isEqualToString:@"i"] ? @"i" : @"t", guid];
    NSString *tmpDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
    
    if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
        return tmpFile;
    } else {
        NSLog(@"ERROR! File saved to TMP directory failed！");
        return @"";
    }
}

- (void)accessToImageAccordingToTheAsset:(PHAsset *)asset
                                    size:(CGSize)size
                             contentMode:(PHImageContentMode)mode
                              completion:(void(^)(UIImage *image,NSDictionary *info))completion
{
    static PHImageRequestID requestID = -2;
    
    //    CGFloat scale = [UIScreen mainScreen].scale;
    //    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, 500);
    //
    //    if (requestID >= 1 && size.width / width == scale) {
    //        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    //    }
    //
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = YES;
    
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:mode options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        result = [self normalizedImage:result];
        completion(result, info);
    }];
    
}


- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


- (UIImage *)resizeToSquare:(float)side image:(UIImage *)image {
    float ratio = image.size.width/image.size.height;
    CGSize size;
    CGRect drawRect;
    if (ratio > 1) {
        size = CGSizeMake(side * ratio, side);
        drawRect = CGRectMake(- (size.width - side) / 2, 0, size.width, size.height);
    } else {
        size = CGSizeMake(side, side / ratio);
        drawRect = CGRectMake(0, - (size.height - side) / 2, size.width, size.height);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(side, side));
    [image drawInRect:drawRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
