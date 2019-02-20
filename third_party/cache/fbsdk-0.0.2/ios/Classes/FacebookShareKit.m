#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "FacebookShareKit.h"
#import "NSObject+FBSDKSharingContent.h"

@interface FacebookShareKit()<FBSDKSharingDelegate>
@end

@implementation FacebookShareKit {
    FBSDKShareDialog *_shareDialog;
    FlutterResult _result;
}

- (instancetype)init {
    if ((self = [super init])) {
        _shareDialog = [[FBSDKShareDialog alloc] init];
        _shareDialog.delegate = self;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"FacebookShareKit"
                                     binaryMessenger:[registrar messenger]];
    FacebookShareKit *instance = [[FacebookShareKit alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"shareLinkWithShareDialog" isEqualToString:call.method]) {
        [self shareLinkWithShareDialog:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)shareLinkWithShareDialog:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dictionary= call.arguments[@"content"];
    id<FBSDKSharingContent> content = [NSObject convertFromDictionary:dictionary];
    _shareDialog.shareContent = content;
    if ([_shareDialog canShow]) {
        _result = result;
        [_shareDialog show];
    } else {
        result(@{@"error": @"Share content error"});
    }
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (_result) {
        _result(@{@"result": results});
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    if (_result) {
        _result(@{@"error": error.description});
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    if (_result) {
        _result(@{@"result": @{@"isCanceled": @YES}});
    }
}

@end
