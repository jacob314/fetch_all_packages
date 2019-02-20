//
//  NSString+MD5.h
//  Pods-Runner
//
//  Created by 陈凯 on 2018/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ImageCachePath      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"] //资源存储地址

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD5)

+(NSString*)getFileMD5WithPath:(NSString*)path;

+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *) colorWithHexString:(NSString *)color;
- (BOOL)isTraimString;
- (NSString *)trimString;
- (NSString *)md5;
- (CGSize)getStringSizewithStringFont:(NSDictionary *)attirbutes withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth;
- (UIImage *)imageFromAttributes:(NSDictionary *)attributes size:(CGSize)size andMD5:(NSString *)md5 andLineHeight:(float)height;

@end

NS_ASSUME_NONNULL_END
