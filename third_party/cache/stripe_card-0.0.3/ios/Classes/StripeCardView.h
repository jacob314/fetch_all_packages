//
//  StripeCardView.h
//  Pods-Runner
//
//  Created by ll on 2018/12/7.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <Stripe/Stripe.h>

NS_ASSUME_NONNULL_BEGIN

@interface StripeCardView : NSObject<FlutterPlatformView>
@property (nonatomic) STPPaymentCardTextField* paymentCardTextField;

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;

@end

@interface StripeWidgetFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


NS_ASSUME_NONNULL_END
