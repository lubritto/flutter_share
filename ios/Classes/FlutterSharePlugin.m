#import "FlutterSharePlugin.h"
#import <flutter_share/flutter_share-Swift.h>

@implementation FlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSharePlugin registerWithRegistrar:registrar];
}
@end
