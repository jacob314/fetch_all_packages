//
// Created by cjl on 2018/9/8.
//

#import "UIImage+scale.h"

@implementation UIImage (scale)
- (UIImage *)scaleWithMinWidth:(CGFloat)minWidth minHeight:(CGFloat)minHeight {
    float w = self.size.width;
    float h = self.size.height;

    float sW = w / minWidth;
    float sH = h / minHeight;

    float scale = fmaxf(fmaxf(sW, sH), 1);

    CGSize s = CGSizeMake(w / scale, h / scale);
    UIGraphicsBeginImageContext(s);

    [self drawInRect:CGRectMake(0, 0, s.width, s.height)];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)rotate:(CGFloat) rotate{
    return [self imageRotatedByDegrees:self deg:rotate];
}

- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
//    NSLog(@"will rotate %f",degrees);
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
