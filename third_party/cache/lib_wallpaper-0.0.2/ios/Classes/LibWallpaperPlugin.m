#import "LibWallpaperPlugin.h"
#import <lib_wallpaper/lib_wallpaper-Swift.h>

@implementation LibWallpaperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLibWallpaperPlugin registerWithRegistrar:registrar];
}
@end
