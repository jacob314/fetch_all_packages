//
//
#import "CameraViewController.h"
#import "TextdetectWidgetPlugin.h"
#import "UIUtilities.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <Firebase/Firebase.h>
#import <AudioToolbox/AudioToolbox.h>
#import "sys/utsname.h"


static NSString *const videoDataOutputQueueLabel = @"com.google.firebaseml.visiondetector.VideoDataOutputQueue";
static NSString *const sessionQueueLabel = @"com.google.firebaseml.visiondetector.SessionQueue";
@interface CameraViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    SystemSoundID mySound;
    CIContext *context;
    CGFloat imageScale;
    BOOL isAvailable;
}
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isFocused;
@property (nonatomic) int focusedId;
@property (nonatomic) NSString* lastCompany;
@property (nonatomic, nonnull) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) FIRVision *vision;
@property (nonatomic) UIView *annotationOverlayView;
@property (nonatomic) UIImageView *previewOverlayView;
@property (nonatomic) UIView *cameraView;
@property (nonatomic) UIImageView *plusImageView;
@property (nonatomic) UIView *focusView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _focusedId = 0;
    _isPaused = NO;
    isAvailable = YES;
    imageScale = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartDetection:) name:@"startDetection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStopDetection:) name:@"stopDetection" object:nil];
     _cameraView = [[UIView alloc] init];
    _cameraView.backgroundColor = UIColor.blackColor;
        [self.view addSubview:_cameraView];
        [_cameraView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint
                                                            constraintWithItem:self.cameraView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                            constant:0];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                                              constraintWithItem:self.cameraView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                              multiplier:1.0
                                              constant:0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.cameraView
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self.view
                                                  attribute:NSLayoutAttributeHeight
                                                  multiplier:1.0
                                                  constant:0];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint
                                  constraintWithItem:self.cameraView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.view
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1.0
                                  constant:0];

        [self.view addConstraint:leftConstraint];
        [self.view addConstraint:widthConstraint];
        [self.view addConstraint:topConstraint];
        [self.view addConstraint:heightConstraint];

    _focusView = [[UIView alloc] init];
    [self.view addSubview:_focusView];
    [self.previewOverlayView setContentMode:UIViewContentModeScaleAspectFill];
    [_focusView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *_centerConstraint = [NSLayoutConstraint
                                          constraintWithItem:_focusView
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0
                                          constant:0];
    NSLayoutConstraint *_topConstraint = [NSLayoutConstraint
                                         constraintWithItem:_focusView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                         constant:150];
    NSLayoutConstraint *_widthConstraint = [NSLayoutConstraint
                                            constraintWithItem:_focusView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1.0
                                            constant:300];
    NSLayoutConstraint *_heightConstraint = [NSLayoutConstraint
                                           constraintWithItem:_focusView
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1.0
                                           constant:60];
    
    [self.view addConstraint:_topConstraint];
    [self.view addConstraint:_centerConstraint];
    [self.view addConstraint:_widthConstraint];
    [self.view addConstraint:_heightConstraint];
    [NSLayoutConstraint activateConstraints:@[_topConstraint,_centerConstraint, widthConstraint,heightConstraint]];
    
    UIImageView* focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    NSString* focusPath = [[NSBundle mainBundle] pathForResource:@"flutter_assets/packages/textdetect_widget/asset/focus_camera.png" ofType:nil];
    NSString* plusPath = [[NSBundle mainBundle] pathForResource:@"flutter_assets/packages/textdetect_widget/asset/plus_icon.png" ofType:nil];
    NSURL *focus_url = [NSURL fileURLWithPath:focusPath];
    NSURL *plus_url = [NSURL fileURLWithPath:plusPath];
    UIImage* focusImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:focus_url]];
    UIImage* plusImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:plus_url]];
    focusImageView.image = focusImage;
    _plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((focusImageView.bounds.size.width - 25) / 2, (focusImageView.bounds.size.height - 25) / 2, 25, 25)];
    _plusImageView.image = plusImage;
    [_focusView addSubview:focusImageView];
    [_focusView addSubview:_plusImageView];
    
    _isFocused = NO;
    _captureSession = [[AVCaptureSession alloc] init];
    _sessionQueue = dispatch_queue_create(sessionQueueLabel.UTF8String, nil);
    _vision = [FIRVision vision];
    _previewOverlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _previewOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    _annotationOverlayView = [[UIView alloc] initWithFrame:CGRectZero];
    _annotationOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self setUpPreviewOverlayView];

//    [self setUpCaptureSessionOutput];
//    [self setUpCaptureSessionInput];
//    [self startSession];
    [self setUpAnnotationOverlayView];
    [self cameraSetup];
}

- (void)cameraSetup {
    _captureSession = [[AVCaptureSession alloc] init];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.zPosition = -1;
    AVCaptureDevice* backDevice;
    
    NSArray* availableDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (int i = 0; i<availableDevices.count; i++) {
        AVCaptureDevice* device = availableDevices[i];
        if (device.position == AVCaptureDevicePositionBack) {
            backDevice = device;
            break;
        }
    }
    
    NSError* error;
    AVCaptureDeviceInput* deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:backDevice error:&error];
    if (!error && deviceInput) {
        if ([self.captureSession canAddInput:deviceInput]) {
            [self.captureSession addInput:deviceInput];
        }
    }
    self.previewLayer.session = self.captureSession;
    [self.cameraView.layer addSublayer:self.previewLayer];
    dispatch_queue_t outputQueue = dispatch_queue_create("Sample Buffer Delegate", nil);
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoOutput setSampleBufferDelegate:self queue:outputQueue];
    videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:  [NSNumber numberWithInteger:kCMPixelFormat_32BGRA]};
    self->_captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.captureSession canAddOutput:videoOutput]) {
        [self.captureSession addOutput:videoOutput];
    }
    
    
    [self.captureSession startRunning];
}

- (void)didStartDetection:(NSNotification*) notification {
    _isPaused = NO;
}

- (void)didStopDetection:(NSNotification*) notification {
    _isPaused = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        [self removeDetectionAnnotations];
    });
}

- (void)addBackButton {
    self.title = @"Live Camera Detection";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)onBack {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopSession];
}

#pragma mark - On-Device Detection
- (void)handleDetection:(FIRVisionText*)result width:(CGFloat)width height:(CGFloat)height{
    BOOL isDetected = false;
    [self->_plusImageView setHidden:NO];
    for (int i=0; i< self.companies.count; i ++) {
        NSString* company = self.companies.allKeys[i];
        if (![result.text.uppercaseString containsString:company.uppercaseString]) {
            continue;
        }
        for (FIRVisionTextBlock* block in result.blocks) {
            if (![block.text.uppercaseString containsString:company.uppercaseString]) {
                continue;
            }
            
            for (FIRVisionTextLine *line in block.lines) {
                if (![line.text.uppercaseString containsString:company.uppercaseString]) {
                    continue;
                }
                isDetected = YES;
                CGFloat min = 0,max = 0;
                for (FIRVisionTextElement *element in line.elements) {
                    if ([company.uppercaseString containsString:element.text.uppercaseString] || [element.text.uppercaseString containsString:company.uppercaseString])
                        {
                        if (min == 0) {
                            min = element.frame.origin.y;
                            max = element.frame.origin.y + element.frame.size.height;
                        }
                        if (min > element.frame.origin.y) {
                            min = element.frame.origin.y;
                        }
                        if (max < element.frame.origin.y + element.frame.size.height) {
                            max = element.frame.origin.y + element.frame.size.height;
                        }
                    }
                }
                CGRect normalizedRect = CGRectMake(line.frame.origin.x / width,  min/ height,  line.frame.size.width / width,  (max - min)/ height);
                
                CGFloat originY = width / imageScale * normalizedRect.origin.x + (self.view.bounds.size.height - width / imageScale) / 2;
                CGFloat originX = height / imageScale * normalizedRect.origin.y + (self.view.bounds.size.width - height / imageScale) / 2;
                
                CGFloat cWidth = height / imageScale * normalizedRect.size.height;
                CGFloat cHeight = width / imageScale * normalizedRect.size.width;

                CGRect convertedRect = CGRectMake(originX, originY, cWidth, cHeight);
                CGRect newRect = CGRectMake(convertedRect.origin.x + convertedRect.size.width / 2 - 40, convertedRect.origin.y, 80, 20);
                
                UILabel *label;
                if ([self.annotationOverlayView viewWithTag:i] != nil) {
                    label = [self.annotationOverlayView viewWithTag:i];
                    label.frame = newRect;
                } else {
                    label = [[UILabel alloc] initWithFrame:newRect];
                    label.textColor = UIColor.whiteColor;
                    label.text = self->_companies.allValues[i];
                    label.adjustsFontSizeToFitWidth = YES;
                    label.tag = i;
                    [self.annotationOverlayView addSubview:label];
                }
                
                CGFloat left = (self.view.bounds.size.width - 300) / 2;
                CGFloat right = (self.view.bounds.size.width - 300) / 2 + 300;
                CGFloat top = 150;
                CGFloat bottom = 210;
                if (label.frame.origin.x  > left && label.frame.origin.x + label.frame.size.width < right && label.frame.origin.y > top && label.frame.origin.y + label.frame.size.height < bottom) {
                    [self removeDetectionAnnotations];
                    [self.annotationOverlayView addSubview:label];
                    if (!self.isFocused) {
                        if (![self.lastCompany isEqualToString:company]) {
                            NSLog(@"%@",@"Focused");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.plusImageView setHidden:YES];
                                [UIView animateWithDuration:0.5 animations:^{
                                    self->_focusView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                } completion:^(BOOL finished) {
                                    self->_focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                }];
                                NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"flutter_assets/packages/textdetect_widget/asset/detect_sound.mp3" ofType:nil]; AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([[NSURL alloc] initWithString:soundPath]), &self->mySound);
                                AudioServicesPlaySystemSound(self->mySound);
                                [self.delegate companyDetected:label.text];
                                self.isFocused = YES;
                                self.focusedId = i;
                                self.lastCompany = company;
                            });
                        }
                    }
                    return;
                } else {
                    if (self.isFocused) {
                        if (self.focusedId == i) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self->_plusImageView setHidden:NO];
                                self.isFocused = NO;
                            });
                        }
                    }
                }
            }
        }
    }
    if (!isDetected) {
        [self removeDetectionAnnotations];
    }
}

- (void)recognizeTextOnDeviceInImage:(FIRVisionImage *)image width:(CGFloat) width height:(CGFloat)height buffer:(CMSampleBufferRef)buffer{
    isAvailable = NO;
    FIRVisionTextRecognizer *textRecognizer = [_vision onDeviceTextRecognizer];
    dispatch_async(dispatch_get_main_queue(), ^{
    [textRecognizer processImage:image completion:^(FIRVisionText * _Nullable text, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Your main thread code goes in here
//            [self removeDetectionAnnotations];
            if (text == nil) {
                self.isFocused = false;
                [self removeDetectionAnnotations];
                self->isAvailable = YES;
                return;
            }
            [self handleDetection:text width:width height:height];
            self->isAvailable = YES;
        });
    }];
    });
}

#pragma mark - Private

- (void)setUpCaptureSessionOutput {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession beginConfiguration];
        // When performing latency tests to determine ideal capture settings,
        // run the app in 'release' mode to get accurate performance metrics
//        self->_captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: [self getPixelType]};
        dispatch_queue_t outputQueue = dispatch_queue_create(videoDataOutputQueueLabel.UTF8String, nil);
        [output setSampleBufferDelegate:self queue:outputQueue];
        
        if ([self.captureSession canAddOutput:output]) {
            [self.captureSession addOutput:output];
            [self.captureSession commitConfiguration];
        } else {
            NSLog(@"%@", @"Failed to add capture session output.");
        }
    });
}

- (NSNumber*)getPixelType {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* deviceName = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    if ([deviceName isEqualToString:@"iPhone10,1"] || [deviceName isEqualToString:@"iPhone10,4"]) {
        return [NSNumber numberWithInteger:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    }
    
    return [NSNumber numberWithInteger:kCMPixelFormat_32BGRA];
    
}

- (void)setUpCaptureSessionInput {
    dispatch_async(_sessionQueue, ^{
        AVCaptureDevicePosition cameraPosition = AVCaptureDevicePositionBack;
        AVCaptureDevice *device = [self captureDeviceForPosition:cameraPosition];
        if (device) {
            [self->_captureSession beginConfiguration];
            NSArray<AVCaptureInput *> *currentInputs = self.captureSession.inputs;
            for (AVCaptureInput *input in currentInputs) {
                [self.captureSession removeInput:input];
            }
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                NSLog(@"Failed to create capture device input: %@", error.localizedDescription);
                return;
            } else {
                if ([self.captureSession canAddInput:input]) {
                    [self.captureSession addInput:input];
                } else {
                    NSLog(@"%@", @"Failed to add capture session input.");
                }
            }
            [self.captureSession commitConfiguration];
        } else {
            NSLog(@"Failed to get capture device for camera position: %ld", (long)cameraPosition);
        }
    });
}

- (void)startSession {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession startRunning];
    });
}

- (void)stopSession {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession stopRunning];
    });
}

- (CGFloat)getImageScaleWithWidth:(CGFloat)width height:(CGFloat)height {
    CGFloat xScale = width / self.view.bounds.size.width;
    CGFloat yScale = height / self.view.bounds.size.height;
    return MIN(xScale, yScale);
    
}
- (void)setUpPreviewOverlayView {
    [_cameraView addSubview:_previewOverlayView];
    [NSLayoutConstraint activateConstraints:@[
                                              [_previewOverlayView.centerXAnchor constraintEqualToAnchor:_cameraView.centerXAnchor],
                                              [_previewOverlayView.centerYAnchor constraintEqualToAnchor:_cameraView.centerYAnchor]
                                              ]];
}
- (void)setUpAnnotationOverlayView {
    [_cameraView addSubview:_annotationOverlayView];
    [NSLayoutConstraint activateConstraints:@[
                                              [_annotationOverlayView.topAnchor constraintEqualToAnchor:_cameraView.topAnchor],
                                              [_annotationOverlayView.leadingAnchor constraintEqualToAnchor:_cameraView.leadingAnchor],
                                              [_annotationOverlayView.trailingAnchor constraintEqualToAnchor:_cameraView.trailingAnchor],
                                              [_annotationOverlayView.bottomAnchor constraintEqualToAnchor:_cameraView.bottomAnchor]
                                              ]];
}

- (AVCaptureDevice *)captureDeviceForPosition:(AVCaptureDevicePosition)position  {
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                                               mediaType:AVMediaTypeVideo
                                                                                                                position:AVCaptureDevicePositionUnspecified];
    for (AVCaptureDevice *device in discoverySession.devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)removeDetectionAnnotations {
    for (UIView *annotationView in _annotationOverlayView.subviews) {
        [annotationView removeFromSuperview];
    }
}

//- (void)updatePreviewOverlayView:(CMSampleBufferRef)buffer {
//    UIImage* image = [CVWrapper imageFromSampleBuffer:buffer scale:self->imageScale];
//    [self.previewOverlayView setImage:image];
//    CFRetain(buffer);
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(buffer);
//    if (imageBuffer == nil) {
//        return;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
//        if (self->context == nil) {
//            self->context = [[CIContext alloc] initWithOptions:nil];
//        }
//        CGImageRef cgImage = [self->context createCGImage:ciImage fromRect:ciImage.extent];
//        if (cgImage == nil) {
//            return;
//        }
//        UIImage *rotatedImage = [UIImage imageWithCGImage:cgImage scale:self->imageScale orientation:UIImageOrientationRight];
//        self.previewOverlayView.image = rotatedImage;
//        CGImageRelease(cgImage);
//        CFRelease(buffer);
//    });
//
//}

- (void)didReceiveMemoryWarning {
    NSLog(@"%@",@"Did Receive Memory warning");
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (!isAvailable) {
        return;
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIImage* image = [CVWrapper imageFromSampleBuffer:sampleBuffer scale:self->imageScale];
//        [self.previewOverlayView setImage:image];
//    });
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (imageBuffer) {
        FIRVisionImage *visionImage = [[FIRVisionImage alloc] initWithBuffer:sampleBuffer];
        FIRVisionImageMetadata *metadata = [[FIRVisionImageMetadata alloc] init];
        UIImageOrientation orientation = [UIUtilities imageOrientationFromDevicePosition:AVCaptureDevicePositionBack];
        FIRVisionDetectorImageOrientation visionOrientation = [UIUtilities visionImageOrientationFromImageOrientation:orientation];
        metadata.orientation = visionOrientation;
        visionImage.metadata = metadata;
        CGFloat imageWidth = CVPixelBufferGetWidth(imageBuffer);
        CGFloat imageHeight = CVPixelBufferGetHeight(imageBuffer);
        dispatch_async(dispatch_get_main_queue(), ^{
            self->imageScale = [self getImageScaleWithWidth:imageHeight height:imageWidth];
            if (!self->_isPaused) {
                [self recognizeTextOnDeviceInImage:visionImage width:imageWidth height:imageHeight buffer:sampleBuffer];
            }
        });
        
    } else {
        NSLog(@"%@", @"Failed to get image buffer from sample buffer.");
    }
}
@end
