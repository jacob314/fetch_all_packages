//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <ice_tea_studio_plugins/IceTeaStudioPluginsPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IceTeaStudioPluginsPlugin registerWithRegistrar:[registry registrarForPlugin:@"IceTeaStudioPluginsPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
}

@end
