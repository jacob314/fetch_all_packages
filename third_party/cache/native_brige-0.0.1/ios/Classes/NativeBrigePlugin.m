#import "NativeBrigePlugin.h"

@implementation NativeBrigePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"native_brige"
            binaryMessenger:[registrar messenger]];
  NativeBrigePlugin* instance = [[NativeBrigePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (NSNumber*)saveToUserDefault:(id)value namespace:(NSString*)nameSpace{
    
    [[NSUserDefaults standardUserDefaults] setObject:value
                                              forKey:nameSpace];
    
    return [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults] synchronize]];
}
    
    
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
 
  }else if([@"saveValueToNativeDict" isEqualToString:call.method]){
    
      NSArray * arguments =(NSArray*)call.arguments;
      if([arguments count] == 2){
          
          result([self saveToUserDefault:arguments[0]
                               namespace:arguments[1]]);
      }
      
  }else if([@"getValueFromNativeDict" isEqualToString:call.method]){
      
    result([[NSUserDefaults standardUserDefaults] objectForKey:call.arguments[0]]);

  }else{
    result(FlutterMethodNotImplemented);
  }
  
}

@end
