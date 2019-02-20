#import "EZDropdown.h"

@implementation EZDropdown

+ (void)message:(nullable NSString *)message
     background:(nullable UIColor *)background
     foreground:(nullable UIColor *)foreground
{
    UIView *alert = [EZDropdown message:message
                                  foreground:(foreground ? foreground : [UIColor whiteColor])
                                  background:(background ? background : [UIColor redColor])
                                     inset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];

    [[EZDropdown window] addSubview:alert];

    [UIView animateWithDuration:0.3f
                     animations:^{
                         alert.frame = CGRectMake(alert.frame.origin.x,
                                                  0.0f,
                                                  alert.frame.size.width,
                                                  alert.frame.size.height);
                     }];

    [[EZDropdown sharedInstance] performSelector:@selector(dismiss:)
                                           withObject:alert
                                           afterDelay:3.0f];
}

#pragma mark Private methods

static EZDropdown *instance = nil;
+ (nonnull EZDropdown *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [EZDropdown new];
    });
    return instance;
}

+ (nonnull UIView *)message:(nullable NSString *)message
                 foreground:(nullable UIColor *)foregroundColor
                 background:(nullable UIColor *)backgroundColor
                      inset:(UIEdgeInsets)insets
{
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    CGSize titleSize = CGSizeZero;
    CGSize messageSize = CGSizeZero;

    if(message.length > 0) {
        messageSize = [message boundingRectWithSize:CGSizeMake(screenWidth - insets.left - insets.right,
                                                               NSIntegerMax)
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0f]}
                                            context:nil].size;
    }

    titleSize.width     = (CGFloat)ceil(titleSize.width);
    titleSize.height    = (CGFloat)ceil(titleSize.height);
    messageSize.width   = (CGFloat)ceil(messageSize.width);
    messageSize.height  = (CGFloat)ceil(messageSize.height);

    CGSize size = CGSizeMake(screenWidth,
                             insets.top + insets.bottom + titleSize.height + messageSize.height + statusBarHeight);

    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                             -size.height,
                                                             screenWidth,
                                                             size.height)];
    alert.backgroundColor = backgroundColor;
    alert.layer.zPosition = MAXFLOAT;
    alert.isAccessibilityElement = YES;
    alert.accessibilityIdentifier = @"DropdownAlert";
    [alert addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:[EZDropdown sharedInstance]
                                                                        action:@selector(dismiss:)]];

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left,
                                                                      insets.top + statusBarHeight,
                                                                      alert.bounds.size.width - insets.left - insets.right,
                                                                      messageSize.height)];
    messageLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    messageLabel.text = message;
    messageLabel.textColor = foregroundColor;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = backgroundColor;
    messageLabel.numberOfLines = NSIntegerMax;
    [alert addSubview:messageLabel];

    return alert;
}

- (void)dismiss:(id)sender
{
    UIView *alert = nil;
    if([sender isKindOfClass:[UIGestureRecognizer class]]) alert = [sender view];
    if([sender isKindOfClass:[UIView class]]) alert = sender;

    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frame = alert.frame;
                         frame.origin.y = -alert.bounds.size.height;
                         alert.frame = frame;
                     } completion:^(BOOL finished) {
                         [alert removeFromSuperview];
                     }];
}

+ (nullable UIWindow *)window
{
    NSEnumerator *windows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    for(UIWindow *window in windows) {
        if(window.windowLevel == UIWindowLevelNormal && !window.hidden) {
            return window;
        }
    }
    return nil;
}

@end
