#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

// - (BOOL)application:(UIApplication *)application
//     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   // Provide the GoogleMaps API key.
//   NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y"];
//   if ([mapsApiKey length] == 0) {
//     mapsApiKey = @"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y";
//   }
//   [GMSServices provideAPIKey:mapsApiKey];
  
//   [GeneratedPluginRegistrant registerWithRegistry:self];
//   // Override point for customization after application launch.
//   return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//  AppDelegate.m
#import <FBSDKCoreKit/FBSDKCoreKit.h>

- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];
  // Add any custom logic here.
  return YES;
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url 
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

  BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
    openURL:url
    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
  ];
  // Add any custom logic here.
  return handled;
}

@end
