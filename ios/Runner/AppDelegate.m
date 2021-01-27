#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "SystemConfiguration/CaptiveNetwork.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.example.commute/wifi" binaryMessenger:controller.binaryMessenger];
    
    [channel setMethodCallHandler: ^(FlutterMethodCall* call, FlutterResult result){
        if([@"getBssid" isEqualToString:call.method]) {
            NSString* bssid = [self getBSSID];
            result(bssid);
        }else if([@"getMacAddress" isEqualToString:call.method]){
            NSString* macAddr = [self getMacAddress];
            result(macAddr);
        }else{
            result(FlutterMethodNotImplemented);
        }
    }];
    
    
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSString *)getBSSID {
    CFArrayRef arr = CNCopySupportedInterfaces();
    CFStringRef interfaceNm = CFArrayGetValueAtIndex(arr, 0);
    CFDictionaryRef captiveNtwrDict = CNCopyCurrentNetworkInfo(interfaceNm);
    NSDictionary* dict = (__bridge NSDictionary*) captiveNtwrDict;
    NSLog(@"DICT DESCIPTIONs : %@", [dict description]);
    NSString* bssid = [dict objectForKey:@"BSSID"];
    NSLog(@"BSSID : %@",[bssid description]);
    return bssid;
}

- (NSString *)getMacAddress {
    CFArrayRef arr = CNCopySupportedInterfaces();
    CFStringRef interfaceNm = CFArrayGetValueAtIndex(arr, 0);
    CFDictionaryRef captiveNtwrDict = CNCopyCurrentNetworkInfo(interfaceNm);
    NSDictionary* dict = (__bridge NSDictionary*) captiveNtwrDict;
    NSLog(@"DICT DESCIPTIONs : %@", [dict description]);
    NSString* bssid = [dict objectForKey:@"BSSID"];
    NSLog(@"BSSID : %@",[bssid description]);
    return bssid;
}
@end
