@import UIKit;

#import "DocumentChooserPlugin.h"
#import <document_chooser/document_chooser-Swift.h>

@interface DocumentChooserPlugin ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
@end

@implementation DocumentChooserPlugin{
    bool _multiple;
    FlutterResult _result;
    UIViewController *_viewController;
    UIDocumentPickerViewController *_pickerController;
    UIDocumentInteractionController *_interactionController;
}

//@implementation DocumentChooserPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"document_chooser"
            binaryMessenger:[registrar messenger]];

    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);

    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;

    DocumentChooserPlugin *instance = [[DocumentChooserPlugin alloc] initWithViewController:viewController];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _pickerController = [[UIDocumentPickerViewController alloc]
                                                               initWithDocumentTypes:@[@"public.item"]
                                                               inMode:UIDocumentPickerModeImport];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // I honestly do not undertsand below code but it was implemented by Flutter team in ImagePicker
    // https://github.com/flutter/plugins/blob/master/packages/image_picker/ios/Classes/ImagePickerPlugin.m
    // and it seems work
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }


  if ([@"chooseDocument" isEqualToString:call.method]) {

      _pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
      _pickerController.delegate = self;
      _pickerController.allowsMultipleSelection = false;
      _result = result;
      _multiple = false;
      [_viewController presentViewController:_pickerController animated:YES completion:nil];

  }else if ([@"chooseDocuments" isEqualToString:call.method]) {

        _pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _pickerController.delegate = self;
        _pickerController.allowsMultipleSelection = true;
        _result = result;
        _multiple = true;
        [_viewController presentViewController:_pickerController animated:YES completion:nil];

    }

  /*else if ([@"viewDocument" isEqualToString:call.method]) {

      NSString *documentUrl = call.arguments[@"documentUrl"];

      NSLog(@"Starting to Open doc %@", documentUrl);

      NSURL *docUrl = [NSURL fileURLWithPath:documentUrl];

      _interactionController = [UIDocumentInteractionController interactionControllerWithURL: docUrl];
      _interactionController.delegate = self;


      BOOL isOk = [_interactionController presentPreviewAnimated:YES];
      if(isOk){
          _result = result;
      }else{
          NSLog(@"Failed to Open doc %@", documentUrl);
          result(@"Failed");
      }
  } */
  else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller
didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    if(_multiple){
        //multiple documents to do
        NSMutableArray *res = [NSMutableArray array];
        for(NSURL *url in res){
             //NSURL *url = [urls objectAtIndex:i];
             NSString *resultFilePath = [url path];
            [res addObject: resultFilePath];
            _result(res);
        }

    }else{
        NSURL *url = [urls objectAtIndex:0];
        NSString *resultFilePath = [url path];
        NSLog( @"Finished picking document:%@",resultFilePath);
        _result(resultFilePath);
    }
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    _result(@"Finished");
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    NSLog(@"Finished");
    return  _viewController;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    NSLog(@"Starting to send document result %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    NSLog(@"We're done sending the document.");
}


@end
