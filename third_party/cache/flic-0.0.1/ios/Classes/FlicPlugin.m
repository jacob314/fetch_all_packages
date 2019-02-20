#import "FlicPlugin.h"

@implementation FlicPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flic"
            binaryMessenger:[registrar messenger]];
  FlicPlugin* instance = [[FlicPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

static NSString * const pluginNotInitializedMessage = @"flic is not initialized";
static NSString * const TAG = @"[TAF Flic] ";
static NSString * const BUTTON_EVENT_SINGLECLICK = @"singleClick";
static NSString * const BUTTON_EVENT_DOUBLECLICK = @"doubleClick";
static NSString * const BUTTON_EVENT_HOLD = @"hold";
@synthesize onButtonClickCallbackId;

- (void)pluginInitialize
{
    [self log:@"pluginInitialize"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"flicApp" object:nil];
}

- (void) init:(FlutterMethodCall*)call result:(FlutterResult)result
{
    [self log:@"init"];
    
    NSDictionary *config = [command.arguments objectAtIndex:0];
    NSString* APP_ID = [config objectForKey:@"appId"];
    NSString* APP_SECRET = [config objectForKey:@"appSecret"];
    
    self.flicManager = [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:APP_ID appSecret:APP_SECRET backgroundExecution:YES];

}

- (void) flicManagerDidRestoreState:(SCLFlicManager * _Nonnull) manager{
    [self log:@"flicManagerDidRestoreState"];
    
    // setup trigger behavior for already grabbed buttons
    NSArray * kButtons = [[SCLFlicManager sharedManager].knownButtons allValues];
    for (SCLFlicButton *button in kButtons) {
        button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndDoubleClickAndHold;
    }
}

- (void) grabButton:(CDVInvokedUrlCommand*)command
{
    [self log:@"grabButton"];

    NSString *FlicUrlScheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FlicUrlScheme"];
    [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:FlicUrlScheme];
}

- (void) waitForButtonEvent:(CDVInvokedUrlCommand*)command
{
    // do not use it
    return;
}

- (void) triggerButtonEvent:(CDVInvokedUrlCommand*)command
{
    // do not use it
    return;
}

- (void) onButtonClick:(CDVInvokedUrlCommand *)command
{
    self.onButtonClickCallbackId = command.callbackId;
    return;
}

// button received
- (void)flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *)error;
{
    if(error)
    {
        NSLog(@"Could not grab: %@", error);
    }
    
    if(button != nil){
        button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndDoubleClickAndHold;
    }
    
    [self log:@"Grabbed button"];
}

// button was unregistered
- (void)flicManager:(SCLFlicManager *)manager didForgetButton:(NSUUID *)buttonIdentifier error:(NSError *)error;
{
    [self log:@"Unregistered button"];
}

// button was clicked
- (void)flicButton:(SCLFlicButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age
{
    [self log:@"didReceiveButtonClick"];

    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:self.onButtonClickCallbackId];
}

// button was double clicked
- (void)flicButton:(SCLFlicButton *)button didReceiveButtonDoubleClick:(BOOL)queued age:(NSInteger)age
{
    [self log:@"didReceiveButtonDoubleClick"];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:self.onButtonClickCallbackId];
}

// button was hold
- (void)flicButton:(SCLFlicButton *)button didReceiveButtonHold:(BOOL)queued age:(NSInteger)age
{
    [self log:@"didReceiveButtonHold"];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:self.onButtonClickCallbackId];
}

- (NSDictionary*)getButtonEventObject:(NSString *)event button:(SCLFlicButton *)button queued:(BOOL)queued age:(NSInteger)age
{
    NSDictionary *buttonResult = [self getButtonJsonObject:button];
    NSDictionary *result = @{
                             @"event": event,
                             @"button": buttonResult,
                             @"wasQueued": @(queued),
                             @"timeDiff": [NSNumber numberWithInteger:age]
                             };
    
    return result;
}

- (NSMutableArray*)knownButtons
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSLog(@"get knownButtons");
    
    NSArray * kButtons = [[SCLFlicManager sharedManager].knownButtons allValues];
    for (SCLFlicButton *button in kButtons) {
        NSDictionary* b = [self getButtonJsonObject:button];
        [result addObject:b];
    }
    
    return result;
}

- (NSDictionary*)getButtonJsonObject:(SCLFlicButton *)button
{
    NSDictionary *result = @{
                             @"buttonId": [button.buttonIdentifier UUIDString],
                             @"name": button.userAssignedName,
                             @"color": [self hexStringForColor:button.color],
                             @"colorHex": [self hexStringForColor:button.color],
                             @"connectionState": [self connectionStateForButton:button],
                             @"status": [self connectionStateForButton:button]
                             };
    
    return result;
}

- (NSString *)connectionStateForButton:(SCLFlicButton *)button {
    if(button == nil)
    {
        return @"";
    }
    
    if (button.connectionState == SCLFlicButtonConnectionStateConnected) {
        return @"Connected";
    }else if (button.connectionState == SCLFlicButtonConnectionStateConnecting) {
        return @"Connecting";
    }else if (button.connectionState == SCLFlicButtonConnectionStateDisconnected) {
        return @"Disconnected";
    }else if (button.connectionState == SCLFlicButtonConnectionStateDisconnecting) {
        return @"Disconnecting";
    }
    
    return @"unknown";
}

- (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

- (void)handleOpenURL:(NSNotification*)notification
{
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]]) {
        [[SCLFlicManager sharedManager] handleOpenURL:url];
        
        NSLog(@"handleOpenURL %@", url);
    }
}

// this logic help us to start app in the background
// in case location was changed
- (void) onAppTerminate{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager startMonitoringSignificantLocationChanges];
    } else {
        [locationManager requestAlwaysAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations; {
    [[SCLFlicManager sharedManager] onLocationChange];
}

-(void)log:(NSString *)text
{
    NSLog(@"%@%@", TAG, text);
}

@end
