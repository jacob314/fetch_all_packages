#import "AdmobPlugin.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

NSString *APP_ID = @"";
NSString *AD_UNIT_ID = @"";
NSString *DEVICE_ID = @"";
NSString *TESTING = @"";
NSString *PLACEMENT = @"";

@implementation AdmobPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"admob"
            binaryMessenger:[registrar messenger]];
  AdmobPlugin* instance = [[AdmobPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

NSString *arguments = @"";
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    arguments = call.arguments;
    if ([@"loadInterstitial" isEqualToString:call.method] || [@"loadBanner" isEqualToString:call.method] ) {
        NSArray *list = [arguments componentsSeparatedByString:@","];
        APP_ID = list[0];
        AD_UNIT_ID = list[1];
        DEVICE_ID = list[2];
        TESTING = list[3];
        [self onLoad];
        self.mInterstitialAd = [self createAndLoadInterstitial];
      }
    if ([@"showInterstitial" isEqualToString:call.method]) {
        if (self.mInterstitialAd.isReady) {
            [self.mInterstitialAd presentFromRootViewController: [UIApplication sharedApplication].keyWindow.rootViewController];
        }
    }
    if ([@"showBanner" isEqualToString:call.method]) {
        NSArray *list = [arguments componentsSeparatedByString:@","];
        
        APP_ID = list[0];
        AD_UNIT_ID = list[1];
        DEVICE_ID = list[2];
        TESTING = list[3];
        PLACEMENT = list[4];
        
        [self onLoad];
        self.mBannerAd = [self createAndLoadBanner];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.mBannerAd];
        [self showBanner:self.mBannerAd Place: PLACEMENT];
        result([NSString stringWithFormat: @"Showing%@", PLACEMENT]);
    }
    if ([@"closeBanner" isEqualToString:call.method]) {
         [self closeBanner:self.mBannerAd];
        result(@"notShown");
    }
    
}

- (void)onLoad{
    [GADMobileAds configureWithApplicationID:APP_ID];
}

- (GADInterstitial*)createAndLoadInterstitial
{
    if(![TESTING  isEqual: @"true"]){AD_UNIT_ID = @"ca-app-pub-3940256099942544/4411468910";}
    GADInterstitial *Interstitial = [[GADInterstitial alloc] initWithAdUnitID: AD_UNIT_ID];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:DEVICE_ID, kGADSimulatorID, nil];
    Interstitial.delegate = self;
    [Interstitial loadRequest:request];
    return Interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.mInterstitialAd = [self createAndLoadInterstitial];
}


- (GADBannerView*)createAndLoadBanner
{
    if(![TESTING  isEqual: @"true"]){AD_UNIT_ID = @"ca-app-pub-3940256099942544/2934735716";}
    GADBannerView *Banner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    Banner.delegate = self;
    Banner.hidden = YES;
    Banner.adUnitID = AD_UNIT_ID;
    Banner.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:DEVICE_ID, kGADSimulatorID, nil];
    [Banner loadRequest:request];
    return Banner;
}

- (void)adViewDidReceiveAd:(GADBannerView *)banner {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        banner.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

CGRect initialBannerPosition;
CGRect initialViewPosition;

- (void)showBanner:(UIView *)banner Place:(NSString *)Position{
    
    initialViewPosition = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;
    CGRect mainFrame = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;
    
    int adjustment = 0;
    
    if([Position  isEqual: @"Top"]){
        CGRect frameRect = banner.frame;
        frameRect.origin.y = 0 - (banner.frame.size.height * 1);
        banner.frame = frameRect;
        initialBannerPosition = banner.frame;
        adjustment = banner.frame.size.height + 18.0;
    }
    else if([Position isEqual: @"Bottom"]){
        CGRect frameRect = banner.frame;
        frameRect.origin.y = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame.size.height;
        banner.frame = frameRect;
        initialBannerPosition = banner.frame;
        adjustment = banner.frame.size.height * -1;
        mainFrame.size.height += adjustment;
    }
    
    if (banner && [banner isHidden]) {
        banner.hidden = NO;
        [UIView animateWithDuration:0.8 animations:^{
            banner.frame = CGRectOffset(banner.frame, 0, adjustment);
            [UIApplication sharedApplication].keyWindow.rootViewController.view.frame = CGRectOffset(mainFrame, 0, 0);
        } completion:^(BOOL finished) {
            //code for completion
        }];
    }
}

-(void)closeBanner:(UIView *)banner{
    [UIView animateWithDuration:0.8 animations:^{
        banner.frame = initialBannerPosition;
        [UIApplication sharedApplication].keyWindow.rootViewController.view.frame = initialViewPosition;
    } completion:^(BOOL finished) {
        //code for completion
    }];
}


@end
