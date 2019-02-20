#import "PhotoPickerPlugin.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetSelectionLabel.h>
#import "PhotoCache.h"

@interface PhotoPickerPlugin () <CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) FlutterResult result;
@property (nonatomic, strong) NSDictionary * args;

@property (nonatomic, strong) CTAssetsPickerController *picker;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation PhotoPickerPlugin

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"photo_picker"
                                     binaryMessenger:[registrar messenger]];
    PhotoPickerPlugin* instance = [[PhotoPickerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.result = result;
    self.args = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
    
    NSLog(@"PhotoPickerPlugin have recieved call.method=%@, call.args=%@", call.method, call.arguments);
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
        
    } else if ([@"photoPicker" isEqualToString:call.method]){
        [self presentPickerController];
        
    } else if ([@"camera" isEqualToString:call.method]) {
        [self showCamera];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)presentPickerController {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.picker = [[CTAssetsPickerController alloc] init];
            self.picker.delegate = self;
            self.picker.showsSelectionIndex = YES;
            self.picker.title = @"相册";
            self.picker.doneButtonTitle = @"完成";
            self.picker.showsCancelButton = YES;
            self.picker.alwaysEnableDoneButton = NO;
            self.picker.showsNumberOfAssets = NO;
            
            CTAssetSelectionLabel *assetSelectionLabel = [CTAssetSelectionLabel appearance];
            [assetSelectionLabel setSize:CGSizeMake(18.0, 18.0)];
            [assetSelectionLabel setCornerRadius:9.0];
            [assetSelectionLabel setMargin:6.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeTop];
            [assetSelectionLabel setTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                                     NSBackgroundColorAttributeName : [UIColor colorWithRed:235.0f/255.0f green:51.0f/255.0f blue:73.0f/255.0f alpha:1.0f]}];
            
            // 默认展示相册/集合
            if ([[self.args objectForKey:@"cameraRollFirst"] boolValue]) {
                self.picker.defaultAssetCollection = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
            }
            
            
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                self.picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self.rootViewController presentViewController:self.picker animated:YES completion:nil];
        });
    }];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    PhotoCache * pc = [PhotoCache manager];
    [pc savePhotos:assets
              mode:[self.args[@"mode"] isEqualToString:@"fill"] ? PHImageContentModeAspectFill : PHImageContentModeAspectFit
        completion:^(NSArray * _Nonnull photoUrls) {
            self.result(photoUrls);
        }];
    
    self.result(@"finished");
    [self.picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss");
    }];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = [[self.args objectForKey:@"limit"] integerValue];
    if (max == 0) {
        return TRUE;
    }
    
    // show alert gracefully
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@""
                                            message:[NSString stringWithFormat:@"最多选择%ld张照片", (long)max]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"好的"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alert addAction:action];
        
        [picker presentViewController:alert animated:YES completion:nil];
    }
    
    // limit selection to max
    return (picker.selectedAssets.count < max);
}

- (void)showCamera {
    // Camera is not available on simulators
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.allowsEditing = [self.args[@"edit"] boolValue];
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        self.imagePickerController.delegate = self;
        
        [self.rootViewController presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"相机不可用"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取当前媒体资源的类型
    UIImage *theImage = nil;
    if ([picker allowsEditing]){
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSString * i_path = [[PhotoCache manager] saveToTmpDir:theImage type:@"i"];
    NSString * t_path = [[PhotoCache manager] saveToTmpDir:[[PhotoCache manager] resizeToSquare:300 image:theImage] type:@"t"];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:theImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%@",@"保存成功");
        }
    }];
    
    self.result(@[@{
                      @"i": i_path,
                      @"t": t_path
                      }]);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
