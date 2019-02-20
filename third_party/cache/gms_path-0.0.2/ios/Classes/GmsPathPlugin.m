#import "GmsPathPlugin.h"

@implementation GmsPathPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"gms_path"
            binaryMessenger:[registrar messenger]];
  GmsPathPlugin* instance = [[GmsPathPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"createPathInstance" isEqualToString:call.method]){
        [self createPathInstance];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"addCoordinate" isEqualToString:call.method]){
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        [self addCoordinateWithLatitude:[[arguments objectForKey:@"latitude"] doubleValue]
                           andLongitude:[[arguments objectForKey:@"longitude"] doubleValue]];
        result([NSNumber numberWithBool:YES]);
    } else if ([@"getEncodedString" isEqualToString:call.method]){
        result([self getEncodedString]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)createPathInstance{
    self.path = [[GMSMutablePath alloc] init];
}

-(void)addCoordinateWithLatitude:(double)latitude andLongitude:(double)longitude{
    if (!self.path) {
        self.path = [[GMSMutablePath alloc] init];
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.path addCoordinate:coordinate];
}

-(NSString *)getEncodedString{
    if (!self.path) {
        self.path = [[GMSMutablePath alloc] init];
    }
    return [self.path encodedPath];
}



@end
