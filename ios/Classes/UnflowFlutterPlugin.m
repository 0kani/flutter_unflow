#import "UnflowFlutterPlugin.h"
#if __has_include(<unflow_flutter/unflow_flutter-Swift.h>)
#import <unflow_flutter/unflow_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "unflow_flutter-Swift.h"
#endif

@implementation UnflowFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUnflowFlutterPlugin registerWithRegistrar:registrar];
}
@end
