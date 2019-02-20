//
//  VoiceRecognitionView.m
//  Pods-Runner
//
//  Created by mac on 2018/12/24.
//

#import "VoiceRecognitionView.h"
#import <Speech/Speech.h>

@implementation VoiceRecognitionFactory {
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
    VoiceRecognitionView* voiceRecognitionView =
    [[VoiceRecognitionView alloc] initWithWithFrame:frame
                                  viewIdentifier:viewId
                                       arguments:args
                                 binaryMessenger:_messenger];
    return voiceRecognitionView;
}

@end
@interface VoiceRecognitionView()
@property (nonatomic) SFSpeechRecognizer* speechRecognizer;
@property (nonatomic) AVAudioEngine* audioEngine;
@property (nonatomic) CADisplayLink* audioRecorderDisplayLink;
//private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//
//private var recognitionTask: SFSpeechRecognitionTask?
@property (nonatomic) SFSpeechRecognitionTask* recognitionTask;
@property (nonatomic) SFSpeechAudioBufferRecognitionRequest* recognitionRequest;
@property (nonatomic) AVAudioRecorder* audioRecorder;
@property (nonatomic) ATAudioVisualizer* audioVisualizer;
@property (nonatomic) NSURL* recordUrl;

@end

@implementation VoiceRecognitionView{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NSDictionary* companies;
    UIView* mView;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        companies = (NSDictionary*)args;
        NSString* channelName = [NSString stringWithFormat:@"voice_recognition_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        self.audioEngine = [[AVAudioEngine alloc] init];
        __weak __typeof__(self) weakSelf = self;
        
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        mView = [[UIView alloc] init];
        [mView setBackgroundColor:UIColor.clearColor];
        UIColor* visualizerColor = [UIColor colorWithRed:255.0/255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
        _audioVisualizer = [[ATAudioVisualizer alloc] initWithBarsNumber:11 frame:CGRectMake((vc.view.bounds.size.width - 240) / 2, 0 , 240, 66) andColor:visualizerColor];
        [mView addSubview:_audioVisualizer];
        
    }
    return self;
}

- (UIView*)view {
    
    return mView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"voice.start"]) {
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        self.recordUrl = [[[NSFileManager defaultManager] temporaryDirectory]  URLByAppendingPathComponent:@"default"];
        [self activateRecognition:^(BOOL isGranted) {
            if (isGranted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_channel invokeMethod:@"voice.permission" arguments:@(YES)];
                    [self startRecognition];
                });
                
            } else {
                [self->_channel invokeMethod:@"voice.permission" arguments:@(NO)];
            }
        }];
        
    } else  if ([[call method] isEqualToString:@"voice.stop"]) {
        [self stopRecognition];
    } else  if ([[call method] isEqualToString:@"voice.dispose"]) {
        [self dispose];
    }
    
}

- (void)activateRecognition:(void (^)(BOOL isGranted))handler {
//    self.speechRecognizer.delegate = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                handler(YES);
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                handler(NO);
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                handler(NO);
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                handler(NO);
                break;
            default:
                break;
        }
    }];
}

- (void)startRecognition {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self.recognitionRequest endAudio];
    } else {
        self.audioRecorder.delegate = self;
        NSError* error;
        AVAudioFormat* audioFormat = [[AVAudioFormat alloc] initWithSettings:@{AVFormatIDKey:@(kAudioFormatMPEG4AAC), AVSampleRateKey: @(12000), AVNumberOfChannelsKey: @(1), AVEncoderAudioQualityKey: @(AVAudioQualityHigh)}];
        
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.recordUrl format:audioFormat error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.audioRecorder setMeteringEnabled:true];
        [self.audioRecorder prepareToRecord];
        [self startListening];
        if (_audioRecorderDisplayLink == nil) {
            self.audioRecorderDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateRecorder)];
            [self.audioRecorderDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
        [_audioRecorderDisplayLink setPaused:false];
        [_audioRecorder recordForDuration:60.0];
    }
}

-(void)updateRecorder {
    [_audioRecorder updateMeters];
    float averagePower = [_audioRecorder averagePowerForChannel:0];
    float averagePower1 = [_audioRecorder averagePowerForChannel:1];
    float normalizedValue = pow(10, averagePower / 20.0);
    float normalizedValue1 = pow(10, averagePower1 / 20.0);
    
    [_audioVisualizer animateAudioVisualizerWithChannel0Level:2 * normalizedValue andChannel1Level:2 * normalizedValue1];
}

- (void)cancelRecognition {
    if (self.recognitionTask != nil) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
}

- (void)stopRecognition {
    if (_audioEngine.isRunning) {
        [_audioEngine stop];
        [_recognitionRequest endAudio];
    }
    [_audioRecorderDisplayLink setPaused:true];
    [self.audioRecorder deleteRecording];
}

- (void)dispose {
    [self stopRecognition];
    [self.audioRecorderDisplayLink invalidate];
}

- (void)startListening {
    [self cancelRecognition];
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    
    [audioSession setMode:AVAudioSessionModeSpokenAudio error:&error];
    [audioSession setActive:true withOptions:AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:&error];
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode* inputNode = _audioEngine.inputNode;
    if (_recognitionRequest != nil) {
        _recognitionRequest.shouldReportPartialResults = true;
    }
    self.recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result) {
            isFinal = result.isFinal;
            NSLog(@"%@",[[result.transcriptions lastObject] formattedString]);
            [self->_channel invokeMethod:@"voice.result" arguments:result.bestTranscription.formattedString];
        }
        if (!error && isFinal) {
            NSLog(@"isFinal");
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
        }
    }];
    AVAudioFormat* recognitionFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recognitionFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [_audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
}


@end
