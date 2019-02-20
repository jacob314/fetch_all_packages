#import <Flutter/Flutter.h>
#import <fliclib/fliclib.h>

@interface FlicPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) SCLFlicManager *flicManager;

@end
