#import "SaltedfishGalleryInserterPlugin.h"
#import <Photos/Photos.h>
@implementation SaltedfishGalleryInserterPlugin
{
    FlutterResult res;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"saltedfish_gallery_inserter"
            binaryMessenger:[registrar messenger]];
  SaltedfishGalleryInserterPlugin* instance = [[SaltedfishGalleryInserterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    res = result;
  if ([@"insertToGallery" isEqualToString:call.method]) {
      FlutterStandardTypedData *d = call.arguments;
      NSData *data = d.data;

      UIImage *myImage = [UIImage imageWithData:data];
      
      [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
          
                          if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
              
              [self loadImageFinished:myImage];//保存图片到相册
              
                              }else{
                  
                                      //[JLHelperManagerUIAlertWithStr:@"请在系统设置中开启相册授权"WithTitle:@"相册授权未开启"WithVC:selfblock:nil];//未授权可以提示用不进入设置里面打开权限
                  
                                  }
          
                      }];
      
      
    
  }
}


- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
         NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
        NSLog(@"success = %d, error = %@", success, error);
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                
            }];
            
            if (imageAsset)
            {
                PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
                [[PHImageManager defaultManager]
                 requestImageDataForAsset:imageAsset
                 options:imageRequestOptions
                 resultHandler:^(NSData *imageData, NSString *dataUTI,
                                 UIImageOrientation orientation,
                                 NSDictionary *info)
                 {
                     
                     if ([info objectForKey:@"PHImageFileURLKey"]) {
                         
                         NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
                         NSLog(@"path = %@", path.path);
                         [dic setValue:@"success" forKey:@"resultCode"];
                         [dic setValue:@"path" forKey:path.path];
                         self->res(dic);
                    
                     }
                 }];
            }else{
                [dic setValue:@"failed" forKey:@"resultCode"];
                self->res(dic);
            }
        }else{
           
            [dic setValue:@"failed" forKey:@"resultCode"];
            self->res(dic);
        }
        
    }];
}
@end
