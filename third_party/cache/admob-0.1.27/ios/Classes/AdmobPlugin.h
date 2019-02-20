#import <Flutter/Flutter.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdmobPlugin : NSObject<FlutterPlugin,GADInterstitialDelegate,GADBannerViewDelegate>
    @property(nonatomic, strong) GADInterstitial *mInterstitialAd;
    @property(nonatomic, strong) GADBannerView *mBannerAd;
@end
