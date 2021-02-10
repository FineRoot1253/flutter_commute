#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "SystemConfiguration/CaptiveNetwork.h"
#import "GoogleMaps/GoogleMaps.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"com.example.commute/wifi" binaryMessenger:controller.binaryMessenger];
    [GMSServices provideAPIKey:@"AIzaSyBgrFKkkkrOwMmbMlyWCvJsTxSrwAykJC8"];
    [GeneratedPluginRegistrant registerWithRegistry:self];
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
    NSString *bssId = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"ifs DESCIPTIONs : %@", [ifs description]);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"DICT DESCIPTIONs : %@", [info description]);
        if (info[@"BSSID"]) {
            NSLog(@"BSSID : %@",[info description]);
            bssId = info[@"BSSID"];
        }
    }
    return bssId;
}
@end
