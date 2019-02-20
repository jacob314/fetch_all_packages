#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "FacebookLoginKit.h"
#import "FBSDKLoginManagerLoginResult+Extensions.h"

@implementation FacebookLoginKit {
    FBSDKLoginManager *_loginManager;
}

- (instancetype)init {
    if ((self = [super init])) {
        _loginManager = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"FacebookLoginKit"
                                     binaryMessenger:[registrar messenger]];
    FacebookLoginKit *instance = [[FacebookLoginKit alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"loginWithReadPermissions" isEqualToString:call.method]) {
        [self loginWithReadPermissions:call result:result];
    } else if ([@"logInWithPublishPermissions" isEqualToString:call.method]) {
        [self logInWithPublishPermissions:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)loginWithReadPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
    FBSDKLoginManagerRequestTokenHandler requestHandler = ^(FBSDKLoginManagerLoginResult *_result, NSError *_error) {
        if (_error) {
            result(@{@"error": _error.description});
        } else {
            result(@{@"result": [_result parseLoginResult]});
        }
    };
    
    NSArray *permissions = call.arguments[@"permissions"];
    if (permissions == nil) {
        result(@{@"error": @"No permissions defined"});
    }
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [_loginManager logInWithReadPermissions:permissions handler:requestHandler];
}

- (void)logInWithPublishPermissions:(FlutterMethodCall*)call result:(FlutterResult)result {
    FBSDKLoginManagerRequestTokenHandler requestHandler = ^(FBSDKLoginManagerLoginResult *_result, NSError *_error) {
        if (_error) {
            result(@{@"error": _error.description});
        } else {
            result(@{@"result": [_result parseLoginResult]});
        }
    };
    
    NSArray *permissions = call.arguments[@"permissions"];
    if (permissions == nil) {
        result(@{@"error": @"No permissions defined"});
    }
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [_loginManager logInWithPublishPermissions:permissions handler:requestHandler];
}

- (void)shareLinkWithShareDialog:(FlutterMethodCall*)call result:(FlutterResult)result {
    
}

@end
