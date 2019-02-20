#import "UdidPlugin.h"
#import <UDIDEngine.h>
#import <UDIDFaceCompareFactory.h>

@interface UdidPlugin ()<UDIDEngineDelegate>
@property (nonatomic, copy) FlutterResult result;
@end

@implementation UdidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel
                                     methodChannelWithName:@"udid_plugin"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UdidPlugin* instance = [[UdidPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    _result = result;
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"startOCRFlow" isEqualToString:call.method]) {
//      NSDictionary *engineDic = call.arguments;
      [self startOCRFlow:call.arguments];
  } else if ([@"startLivenessFlow" isEqualToString:call.method]) {
      [self startLivenessFlow:call.arguments];
  } else if ([@"startIDAuthFlow" isEqualToString:call.method]) {
      [self startIDAuthFlow:call.arguments];
  } else if ([@"startCompareFlow" isEqualToString:call.method]) {
      [self startCompareFlow:call.arguments];
  } else if ([@"startVideoFlow" isEqualToString:call.method]) {
      [self startVideoFlow:call.arguments];
  } else if ([@"startCustomFlow" isEqualToString:call.method]) {
      [self startCustomFlow:call.arguments];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - 产品动作

// OCR 身份证扫描
- (void)startOCRFlow:(NSDictionary *)engineArg {
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    /* 身份证 OCR 扫描相关参数 */
    ocrEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
    // 是否显示身份证ocr信息
    ocrEngine.showInfo = YES;
    // 身份证号掩码
    ocrEngine.mosaicIdNumber = NO;
    // 身份证号在确认页面明文展示
    ocrEngine.showConfirmIdNumber = NO;
    
    /* 通用参数 */
    ocrEngine.pubKey = engineArg[@"pubKey"];
    ocrEngine.signTime = engineArg[@"singTime"];
    ocrEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    ocrEngine.notifyUrl = engineArg[@"notifyUrl"];
    ocrEngine.sign = engineArg[@"sign"];
    ocrEngine.delegate = self;
    [ocrEngine startIdSafeAuthInViewController:_viewController];
}

// 活体检测
- (void)startLivenessFlow:(NSDictionary *)engineArg {
    UDIDEngine *livenessEngine = [[UDIDEngine alloc] init];
    // 分布动作数组
    livenessEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowLiving]];
    /* 活体检测相关参数 */
    livenessEngine.livingMode = UDIDLivingCommandMode;
    // 活体声音开关
    livenessEngine.closeRemindVoice = NO;
    
    /* 通用参数 */
    livenessEngine.pubKey = engineArg[@"pubKey"];
    livenessEngine.signTime = engineArg[@"singTime"];
    livenessEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    livenessEngine.notifyUrl = engineArg[@"notifyUrl"];
    livenessEngine.sign = engineArg[@"sign"];
    livenessEngine.delegate = self;
    [livenessEngine startIdSafeAuthInViewController:_viewController];
}

// 实名验证
- (void)startIDAuthFlow:(NSDictionary *)engineArg {
    UDIDEngine *idauthEngine = [[UDIDEngine alloc] init];
    // 分布动作数组
    idauthEngine.actions = @[@3];
    // 或者下面的 actions 传入方式
    // idauthEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowRealName]];
    idauthEngine.verifyType = UDIDVerifyHumanType;
    idauthEngine.idName = @"小明";
    idauthEngine.idNumber = @"身份证号码";
    
    /* 通用参数 */
    idauthEngine.pubKey = engineArg[@"pubKey"];
    idauthEngine.signTime = engineArg[@"singTime"];
    idauthEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    idauthEngine.notifyUrl = engineArg[@"notifyUrl"];
    idauthEngine.sign = engineArg[@"sign"];
    idauthEngine.delegate = self;
    [idauthEngine startIdSafeAuthInViewController:_viewController];
}

// 比对
- (void)startCompareFlow:(NSDictionary *)engineArg {
    UDIDEngine *compareEngine = [[UDIDEngine alloc] init];
    // 分布动作数组
    compareEngine.actions = @[@2];
    // 或者下面的 actions 传入方式
    // compareEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowCompare]];
    
    compareEngine.compareItemA = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeNormal];;
    compareEngine.compareItemB = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeLiving];;
    compareEngine.isGridPhoto = NO;
    
    /* 通用参数 */
    compareEngine.pubKey = engineArg[@"pubKey"];
    compareEngine.signTime = engineArg[@"singTime"];
    compareEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    compareEngine.notifyUrl = engineArg[@"notifyUrl"];
    compareEngine.sign = engineArg[@"sign"];
    compareEngine.delegate = self;
    [compareEngine startIdSafeAuthInViewController:_viewController];
}

// 视频存证
- (void)startVideoFlow:(NSDictionary *)engineArg {
    UDIDEngine *videoEngine = [[UDIDEngine alloc] init];
    // 分布动作数组
    videoEngine.actions = @[@5];
    //    videoEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowVideo]];
    videoEngine.readingInfo = @"门前大桥下游过一群鸭，快来快来数一数，二四六七八";
    
    /* 通用参数 */
    videoEngine.pubKey = engineArg[@"pubKey"];
    videoEngine.signTime = engineArg[@"singTime"];
    videoEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    videoEngine.notifyUrl = engineArg[@"notifyUrl"];
    videoEngine.sign = engineArg[@"sign"];
    videoEngine.delegate = self;
    [videoEngine startIdSafeAuthInViewController:_viewController];
}


// 自由组合流程 (例子：实名验证+活体检测+人脸比对)
- (void)startCustomFlow:(NSDictionary *)engineArg {
    UDIDEngine *customEngine = [[UDIDEngine alloc] init];
    customEngine.actions = @[@3, @1, @2];
    // 或者下面的 actions 传入方式
    //    customEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowRealName],
    //                              [NSNumber numberWithUnsignedInteger:UDIDAuthFlowLiving],
    //                              [NSNumber numberWithUnsignedInteger:UDIDAuthFlowCompare]];
    
    customEngine.verifyType = UDIDVerifyHumanType;
    customEngine.idName = @"小明";
    customEngine.idNumber = @"身份证号码";
    
    customEngine.randomCount = 3;
    customEngine.livingModeSettings = @[@0, @1, @2, @3, @6];
    customEngine.livingMode = UDIDLivingCustomMode;
    customEngine.closeRemindVoice = YES;
    
    customEngine.compareItemA = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeLiving];
    customEngine.compareItemB = [UDIDFaceCompareFactory getBytype:UDIDSafePhotoTypeNormal];
    customEngine.isGridPhoto = YES;
    
    /* 通用参数 */
    customEngine.pubKey = engineArg[@"pubKey"];
    customEngine.signTime = engineArg[@"singTime"];
    customEngine.partnerOrderId = engineArg[@"partnerOrderId"];
    customEngine.notifyUrl = engineArg[@"notifyUrl"];
    customEngine.sign = engineArg[@"sign"];
    customEngine.delegate = self;
    [customEngine startIdSafeAuthInViewController:_viewController];
}

#pragma mark - Delegate

- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo {
    
    if (![userInfo[@"success"] isEqualToString:@"1"]) {
        [channel invokeMethod:@"errorResult" arguments:userInfo];
    } else {
        _result(userInfo);
    }
    
    //    NSLog(@"demo:userInfo = %@", userInfo);
//    _result(userInfo);
    // switch (result) {
    //     case UDIDEngineResult_OCR: {
    //         // TODO: 身份证OCR识别 回调
    //         _result(userInfo);
    //         break;
    //     } case UDIDEngineResult_Liveness: {
    //         // TODO: 活体检测 回调
    //         _result(userInfo);
    //         break;
    //     } case UDIDEngineResult_IDAuth: {
    //         // TODO: 实名验证 回调
    //         _result(userInfo);
    //         break;
    //     } case UDIDEngineResult_FaceCompare: {
    //         // TODO: 人脸比对 回调
    //         _result(userInfo);
    //         break;
    //     } case UDIDEngineResult_Video: {
    //         // TODO: 视频存证 回调
    //         _result(userInfo);
    //         break;
    //     } default:
    //         _result(userInfo);
    //         break;
    // }
}

// 拍照
- (void)startTakePhoto {
    NSLog(@"传入的 base 64 格式照片分辨率宽度不得大于500，具体可以参照压缩图片方法，scaledToWidth:(<500)，在转base64(具体参照 imageToNSString: 方法)");
}

#pragma mark - 图片转 base64
-(NSString *)imageToNSString:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - base64 转图片
-(UIImage *)stringToUIImage:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - 压缩图片
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
