#import <Flutter/Flutter.h>

static FlutterMethodChannel *channel;

@interface UdidPlugin : NSObject<FlutterPlugin>
@property (nonatomic, retain) UIViewController *viewController;
@end
