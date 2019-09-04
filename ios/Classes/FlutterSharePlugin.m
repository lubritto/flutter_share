#import "FlutterSharePlugin.h"

@interface FlutterSharePlugin()
@end

@implementation FlutterSharePlugin{
    FlutterResult _result;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                       methodChannelWithName:@"flutter_share"
                                       binaryMessenger:[registrar messenger]];

  FlutterSharePlugin *instance = [FlutterSharePlugin alloc];
  [registrar addMethodCallDelegate:instance channel:channel];
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

    if ([title isEqual:[NSNull null]] || [title length] == 0) {
      return false;
    }

    NSMutableArray *sharedItems = [NSMutableArray array];
    NSMutableArray *textList = [NSMutableArray array];

    // text
    if (![text isEqual:[NSNull null]] && [text length] > 0) {
       [textList addObject:text];
    }
    // Link url
    if (![linkUrl isEqual:[NSNull null]] && [linkUrl length] > 0) {
        [textList addObject:linkUrl];
    }

    NSString *textToShare = @"";

    if ([textList count] > 0) {
        textToShare = [textList componentsJoinedByString:@"\n\n"];
    }

    [sharedItems addObject:textToShare];

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedItems applicationActivities:nil];

    // Subject
    if (![title isEqual:[NSNull null]] && [title length] > 0) {
        [activityViewController setValue:title forKey:@"subject"];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self topViewController] presentViewController:activityViewController animated:YES completion:nil];
    });

    return true;
}

- (bool)shareFile:(FlutterMethodCall*)call {
    NSString *title = call.arguments[@"title"];
    NSString *text = call.arguments[@"text"];
    NSString *filePath = call.arguments[@"filePath"];

    if ([title isEqual:[NSNull null]] || [title length] == 0 || [filePath isEqual:[NSNull null]] || [filePath length] == 0) {
        return false;
    }

    NSMutableArray *sharedItems = [NSMutableArray array];

    // text
    if (![text isEqual:[NSNull null]] && [text length] > 0) {
        [sharedItems addObject:text];
    }

    // Link url
    if (![filePath isEqual:[NSNull null]] && [filePath length] > 0) {
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [sharedItems addObject:fileUrl];
    }

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:sharedItems applicationActivities:nil];

    // Subject
    if (![title isEqual:[NSNull null]] && [title length] > 0) {
        [activityViewController setValue:title forKey:@"subject"];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self topViewController] presentViewController:activityViewController animated:YES completion:nil];
    });

    return true;
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)viewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navContObj = (UINavigationController*)viewController;
        return [self topViewControllerWithRootViewController:navContObj.visibleViewController];
    } else if (viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed) {
        UIViewController* presentedViewController = viewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        for (UIView *view in [viewController.view subviews])
        {
            id subViewController = [view nextResponder];
            if ( subViewController && [subViewController isKindOfClass:[UIViewController class]])
            {
                if ([(UIViewController *)subViewController presentedViewController]  && ![subViewController presentedViewController].isBeingDismissed) {
                    return [self topViewControllerWithRootViewController:[(UIViewController *)subViewController presentedViewController]];
                }
            }
        }
        return viewController;
    }
}

@end
