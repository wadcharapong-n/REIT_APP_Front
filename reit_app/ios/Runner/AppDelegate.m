#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyCD6fMRbaD5XE3ZbYsfVryOMxY-0viOk8Y"];
  [GeneratedPluginRegistrant registerWithRegistry:self];

  [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];


  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// //  AppDelegate.m
// - (BOOL)application:(UIApplication *)application 
//     didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
//   [[FBSDKApplicationDelegate sharedInstance] application:application
//     didFinishLaunchingWithOptions:launchOptions];
//   // Add any custom logic here.
//   return YES;
// }

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
