#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GmsPathPlugin : NSObject<FlutterPlugin>

@property(strong, nonatomic) GMSMutablePath *path;

@end
