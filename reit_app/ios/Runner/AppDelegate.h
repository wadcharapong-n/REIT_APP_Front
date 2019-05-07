#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end

@interface AppDelegate : FlutterAppDelegate

@end
