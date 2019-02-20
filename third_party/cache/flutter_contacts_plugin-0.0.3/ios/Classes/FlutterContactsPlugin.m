#import "FlutterContactsPlugin.h"
#import <flutter_contacts_plugin/flutter_contacts_plugin-Swift.h>


@implementation FlutterContactsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterContactsPlugin registerWithRegistrar:registrar];
}
@end
