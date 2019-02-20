//
//  NSString+MD5.m
//  Pods-Runner
//
//  Created by 陈凯 on 2018/11/28.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation NSString (MD5)

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    NSString * str = (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
    return str;
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

- (BOOL)isTraimString
{
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimedStr = [self stringByTrimmingCharactersInSet:set];
    // 判断新字符串的长度是否为0
    if (trimedStr.length == 0) {
        // 字符串为空
        return NO;
    }
    return YES;
}

- (CGSize)getStringSizewithStringFont:(NSDictionary *)attirbutes withWidthOrHeight:(CGFloat)fixedSize isWidthFixed:(BOOL)isWidth
{
    CGSize   sizeC ;
    
    if (isWidth) {
        sizeC = CGSizeMake(fixedSize ,MAXFLOAT);
    }else{
        sizeC = CGSizeMake(MAXFLOAT ,fixedSize);
    }
    
    CGSize   sizeFileName = [self boundingRectWithSize:sizeC
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attirbutes
                                               context:nil].size;
    
    return sizeFileName;
}

- (UIImage *)imageFromAttributes:(NSDictionary *)attributes size:(CGSize)size andMD5:(NSString *)md5 andLineHeight:(float)height
{
    height += 5;
    
    float scale = 1;
    
    UIGraphicsBeginImageContextWithOptions(size, NO,scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, image.size.width*scale, (image.size.height - height)*scale));
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:ImageCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:ImageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [UIImagePNGRepresentation(newImage) writeToFile:[NSString stringWithFormat:@"%@/%@.png",ImageCachePath,md5] atomically:YES];
    
    return newImage;
}

- (NSString *)md5
{
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    CGFloat a = components[3];
    
    return [[NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
             lroundf(a * 255),
             lroundf(r * 255),
             lroundf(g * 255),
             lroundf(b * 255)] lowercaseString];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = [cString length] >6 ? 2 : 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = [cString length] >6 ? 4 : 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = [cString length] >6 ? 6 : 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b, a = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if([cString length] > 6)
    {
        range.location = 0;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }
    
    return [cString length] > 6 ? [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)] : [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.f];
}

@end
