//
//  StripeCardView.m
//  Pods-Runner
//
//  Created by ll on 2018/12/7.
//

#import "StripeCardView.h"

@implementation StripeWidgetFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    StripeCardView* stripeCardView =
    [[StripeCardView alloc] initWithWithFrame:frame
                                 viewIdentifier:viewId
                                      arguments:args
                                binaryMessenger:_messenger];
    return stripeCardView;
}

@end

@implementation StripeCardView{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NSString* publishKey;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"stripe_card_%lld", viewId];
        publishKey = (NSString*)args;
        [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:publishKey];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    return self;
}

-(UIView*)view {
    self.paymentCardTextField = [[STPPaymentCardTextField alloc] init];
    return self.paymentCardTextField;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"validate"]) {
        result([NSNumber numberWithBool:self.paymentCardTextField.isValid]);
    } else if ([[call method] isEqualToString:@"createToken"]) {
        if (self.paymentCardTextField.isValid) {
            STPCardParams *cardParams = self.paymentCardTextField.cardParams;
            
            [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
                if (token == nil || error != nil) {
                    // Present error to user...
                    result(nil);
                    return;
                }
                result(token.tokenId);
            }];
        } else {
            result(nil);
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


@end
