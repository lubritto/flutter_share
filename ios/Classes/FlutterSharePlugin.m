#import "FlutterSharePlugin.h"
#import <flutter_share/flutter_share-Swift.h>

@interface FlutterSharePlugin()
@end

@implementation FlutterSharePlugin{
    FlutterResult _result;
    UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                       methodChannelWithName:@"flutter_share"
                                       binaryMessenger:[registrar messenger]];
  UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  FlutterSharePlugin *instance = [[FlutterSharePlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"share" isEqualToString:call.method]) {
        result(@([self share:call]));
    }
    else if ([@"shareFile" isEqualToString:call.method]) {
        result(@([self shareFile:call]));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (bool)share:(FlutterMethodCall*)call {
    NSString *title = call.arguments[@"title"];
    NSString *text = call.arguments[@"text"];
    NSString *linkUrl = call.arguments[@"linkUrl"];

    if (title == nil || [title length] == 0) {
      return false;
    }

    NSMutableArray *sharedItems = [NSMutableArray array];
    NSMutableArray *textList = [NSMutableArray array];
    
    // text
    if (text != nil && [text length] > 0) {
       [textList addObject:text];
    }
    // Link url
    if (linkUrl != nil && [linkUrl length] > 0) {
        [textList addObject:linkUrl];
    }
    
    NSString *textToShare = @"";
    
    if ([textList count] > 0) {
        textToShare = [textList componentsJoinedByString:@"\n\n"];
    }
    
    [sharedItems addObject:textToShare];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedItems applicationActivities:nil];
    
    // Subject
    if (title != nil && [title length] > 0) {
        [activityViewController setValue:title forKey:@"subject"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_viewController presentViewController:activityViewController animated:YES completion:nil];
    });
    
    return true;
}

- (bool)shareFile:(FlutterMethodCall*)call {
    NSString *title = call.arguments[@"title"];
    NSString *text = call.arguments[@"text"];
    NSString *filePath = call.arguments[@"filePath"];
    
    if (title == nil || [title length] == 0 || filePath == nil || [filePath length] == 0) {
        return false;
    }
    
    NSMutableArray *sharedItems = [NSMutableArray array];
    
    // text
    if (text != nil && [text length] > 0) {
        [sharedItems addObject:text];
    }
    
    // Link url
    if (filePath != nil && [filePath length] > 0) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [sharedItems addObject:fileUrl];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedItems applicationActivities:nil];
    
    // Subject
    if (title != nil && [title length] > 0) {
        [activityViewController setValue:title forKey:@"subject"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_viewController presentViewController:activityViewController animated:YES completion:nil];
    });
    
    return true;
}

@end
