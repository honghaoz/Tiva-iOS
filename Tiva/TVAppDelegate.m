//
//  TVAppDelegate.m
//  Tiva
//
//  Created by Zhang Honghao on 6/9/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TVAppDelegate.h"
#import "TVMainViewController.h"
#import <Parse/Parse.h>
#import "ZHHParseDevice.h"
#import <Accelerate/Accelerate.h>
#import "TVShowStore.h"
#import <AFNetworkActivityIndicatorManager.h>

@implementation TVAppDelegate

@synthesize fbUserName;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set Parse Id
    [Parse setApplicationId:@"UjD956TYrxLbL58UwNqiSSaHcUBiSp4gs3S0oV5Q"
                  clientKey:@"L4EWXdVhrhsc6GLzkxYe3IYcWsbaG2RMwPhIiiXi"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    TVMainViewController *theMainVC = [[TVMainViewController alloc] init];
    
    self.window.rootViewController = theMainVC;
    [self.window makeKeyAndVisible];
    
    // Parse Track
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    BOOL testMode = NO;
    // If in test Mode, do not track device
    if (!testMode) {
        [ZHHParseDevice trackDevice];
    }
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
//    [PFCloud callFunctionInBackground:@"updateTomorrowData"
//                       withParameters:nil
//                                block:^(NSNumber *ratings, NSError *error) {
//                                    if (!error) {
//                                        // ratings is 4.5
//                                    }
//                                }];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
