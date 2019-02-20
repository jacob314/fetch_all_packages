#import <Flutter/Flutter.h>

@interface WhiteBoardFlutterPlugin : NSObject<FlutterPlugin>

+ (WhiteBoardFlutterPlugin *)sharedWhiteBoardFlutterPluginlManager;

-(void)callMethod:(NSString *)method andParams:(id)params;

@end
