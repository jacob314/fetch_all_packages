#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <hybrid_stack_manager/XURLRouter.h>
#import <hybrid_stack_manager/XFlutterModule.h>
#import "XDemoController.h"

@interface AppDelegate(UIGestureRecognizerDelegate)
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[[XFlutterModule sharedInstance] queryFlutterVCWithURL:@"hrd://fdemo" query:@{@"flutter":@(true)} params:nil]];
    rootNav.interactivePopGestureRecognizer.delegate = self;
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = rootNav;
    [window makeKeyAndVisible];
    self.window = window;
    [self setupNativeOpenUrlHandler];
    return YES;
}

- (void)setupNativeOpenUrlHandler{
    [[XURLRouter sharedInstance] setNativeOpenUrlHandler:^UIViewController *(NSString *url,NSDictionary *query,NSDictionary *params){
        NSURL *tmpUrl = [NSURL URLWithString:url];
        if([@"ndemo" isEqualToString:tmpUrl.host]){
            return [XDemoController new];
        }
        return nil;
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return TRUE;
}
@end
