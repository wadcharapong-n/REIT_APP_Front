#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Provide the GoogleMaps API key.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y";
  }
  [GMSServices provideAPIKey:mapsApiKey];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
