#import "StatusBarColorizer.h"

@interface StatusBarColorizer()
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong) UIView *view;
@end

@implementation StatusBarColorizer

static StatusBarColorizer *instance = nil;
+ (StatusBarColorizer *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [StatusBarColorizer new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        [[StatusBarColorizer delegate] addObserver:self
                                        forKeyPath:@"window"
                                           options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew)
                                           context:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateStatusBarHidden:)
                                                     name:@"UIViewControllerStatusBarUpdate"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateOrientation)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[StatusBarColorizer delegate] removeObserver:self
                                       forKeyPath:@"window"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didUpdateStatusBarHidden:(NSNotification *)noti
{
    [self updateFrameForceHidden:[noti.object boolValue]];
}

- (void)didUpdateOrientation
{
    [self updateFrameForceHidden:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(self.active)
    {
        [self addBarToWindow:[StatusBarColorizer window]];
    }
}

- (void)updateFrameForceHidden:(BOOL)hidden
{
    if(hidden)
    {
        [[self bar] setFrame:CGRectMake(UIApplication.sharedApplication.statusBarFrame.origin.x,
                                        UIApplication.sharedApplication.statusBarFrame.origin.y,
                                        0.0f,
                                        0.0f)];
    }
    else
    {
        [[self bar] setFrame:CGRectMake(UIApplication.sharedApplication.statusBarFrame.origin.x,
                                        UIApplication.sharedApplication.statusBarFrame.origin.y,
                                        UIApplication.sharedApplication.statusBarFrame.size.width,
                                        UIApplication.sharedApplication.statusBarFrame.size.height)];
    }
}

+ (void)show
{
    if(![StatusBarColorizer sharedInstance].active)
    {
        [StatusBarColorizer sharedInstance].active = true;
        [[StatusBarColorizer sharedInstance] addBarToWindow:[self window]];
    }
}

+ (void)hide
{
    if([StatusBarColorizer sharedInstance].active)
    {
        [StatusBarColorizer sharedInstance].active = false;
        [[[StatusBarColorizer sharedInstance] bar] removeFromSuperview];
    }
}

+ (void)color:(UIColor *)color
{
    [[StatusBarColorizer sharedInstance] bar].backgroundColor = color;
}

- (void)addBarToWindow:(UIWindow *)window
{
    [[self bar] removeFromSuperview];
    [self updateFrameForceHidden:NO];
    [[StatusBarColorizer window] addSubview:[self bar]];
}

- (UIView *)bar
{
    if(!self.view)
    {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(UIApplication.sharedApplication.statusBarFrame.origin.x,
                                                             UIApplication.sharedApplication.statusBarFrame.origin.y,
                                                             UIApplication.sharedApplication.statusBarFrame.size.width,
                                                             UIApplication.sharedApplication.statusBarFrame.size.height)];
        self.view.layer.zPosition = 1000;
        self.view.backgroundColor = UIColor.whiteColor;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self.view;
}

+ (UIWindow *)window
{
    return UIApplication.sharedApplication.delegate.window;
}

+ (NSObject *)delegate
{
    return UIApplication.sharedApplication.delegate;
}

@end
