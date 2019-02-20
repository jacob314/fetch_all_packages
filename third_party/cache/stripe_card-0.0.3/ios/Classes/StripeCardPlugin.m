#import "StripeCardPlugin.h"
#import "StripeCardView.h"
@implementation StripeCardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    StripeWidgetFactory* stripeFactory =
    [[StripeWidgetFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:stripeFactory withId:@"stripe_card"];
}

@end
