#import "UIApplication+Swizzling.h"
#import <objc/runtime.h>

/*
 * The only way found to recognize if statusbar changes visibility was to swizzle.
 * Replace this code if another method is found.
 */
@implementation UIApplication (Swizzling)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL defaultSelector = @selector(setStatusBarHidden:withAnimation:);
        SEL swizzledSelector = @selector(swizzled_setStatusBarHidden:withAnimation:);

        Method defaultMethod = class_getInstanceMethod(class, defaultSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL doMethodExists = !class_addMethod(class, defaultSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (doMethodExists) {
            method_exchangeImplementations(defaultMethod, swizzledMethod);
        }
        else {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(defaultMethod), method_getTypeEncoding(defaultMethod));
        }
    });
}

/*
 * Swizzle to detect if statusbar visibility changes, and notify plugin.
 */
- (void)swizzled_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
{
    [self swizzled_setStatusBarHidden:hidden withAnimation:animation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIViewControllerStatusBarUpdate" object:@(hidden)];
}

#pragma clang diagnostic pop

@end
