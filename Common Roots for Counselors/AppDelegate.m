//
//  AppDelegate.m
//  Common Roots
//
//  Created by Spencer Yen on 1/17/15.
//  Copyright (c) 2015 Parameter Labs. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
#import "CRUser.h"
#import "CRLoginViewController.h"
#import "CRConversationManager.h"
#import "CRChatViewController.h"
#import "UIColor+Common_Roots.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"AvenirNext-Regular" size:25.0],
                                                           NSFontAttributeName, [UIColor teamRootsGreen],
                                                           NSForegroundColorAttributeName,  nil]];
    CGFloat verticalOffset = 1;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [Parse setApplicationId:@"pya3k6c4LXzZMy6PwMH80kJx4HD2xF6duLSSdYUl"
                  clientKey:@"BOOijRRSKlKh5ogT2IaacnnK2eHJZqt8L30VPIcc"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [SVProgressHUD setForegroundColor:[UIColor teamRootsGreen]];
    //[SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    
    LYRClient *layerClient = [CRConversationManager layerClient];
    
    [layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Layer Client Connected!");
        } else {
            NSLog(@"Error in layerClient Connection: %@", [error localizedDescription]);
        }
    }];
    
    // Checking if app is running iOS 8
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // Register device for iOS8
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    } else {
        // Register device for iOS7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.tintColor = [UIColor teamRootsGreen];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLayerObjectsDidChangeNotification:)
                                                 name:LYRClientObjectsDidChangeNotification object:layerClient];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSError *error;
    BOOL success = [[CRConversationManager layerClient] updateRemoteNotificationDeviceToken:deviceToken error:&error];
    if (success) {
        NSLog(@"Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //    __block LYRMessage *message = [self messageFromRemoteNotification:userInfo];
    //    [[CRConversationManager sharedInstance] CRConversationForLayerConversationID:message.conversation.identifier client:[CRConversationManager layerClient] completionBlock:^(CRConversation *conversation, NSError *error) {
    //        CRLoginViewController *loginVC = (CRLoginViewController *)self.window.rootViewController;
    //        loginVC.receivedConversationToLoad = conversation;
    //    }];
    //
    //    if (application.applicationState == UIApplicationStateInactive && message) {
    //        [[CRConversationManager sharedInstance] CRConversationForLayerConversationID:message.conversation.identifier client:[CRConversationManager layerClient] completionBlock:^(CRConversation *conversation, NSError *error) {
    //            CRLoginViewController *loginVC = (CRLoginViewController *)self.window.rootViewController;
    //         //   loginVC.receivedConversationToLoad = conversation;
    //        }];
    //    }
    //
    //    BOOL success = [[CRConversationManager layerClient] synchronizeWithRemoteNotification:userInfo completion:^(UIBackgroundFetchResult fetchResult, NSError *error) {
    //        if (fetchResult == UIBackgroundFetchResultFailed) {
    //            NSLog(@"Failed processing remote notification: %@", error);
    //        }
    //
    //        // Try navigating once the synchronization completed
    //        if (application.applicationState == UIApplicationStateInactive && !message) {
    //            message = [self messageFromRemoteNotification:userInfo];
    //            [[ANConversationManager sharedInstance] ANConversationForLayerConversationID:message.conversation.identifier client:[ANConversationManager layerClient] completionBlock:^(ANConversation *conversation, NSError *error) {
    //                ANLoginViewController *loginVC = (ANLoginViewController *)self.window.rootViewController;
    //                loginVC.receivedConversationToLoad = conversation;
    //            }];
    //        }
    //        completionHandler(fetchResult);
    //    }];
    //
    //    if (!success) {
    //        completionHandler(UIBackgroundFetchResultNoData);
    //    }
}

- (void)didReceiveLayerObjectsDidChangeNotification:(NSNotification *)notification {
    NSArray *changes = [notification.userInfo objectForKey:LYRClientObjectChangesUserInfoKey];
    for (NSDictionary *change in changes) {
        id changeObject = [change objectForKey:LYRObjectChangeObjectKey];
        //  NSLog(@"change object in app del :%@", changeObject);
        if ([changeObject isKindOfClass:[LYRConversation class]]) {
            LYRObjectChangeType changeKey = (LYRObjectChangeType)[[change objectForKey:LYRObjectChangeTypeKey] integerValue];
            if(changeKey == LYRObjectChangeTypeCreate){
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate date];
                localNotification.alertBody = @"New Conversation!";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kConversationChangeNotification object:change];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMessageChangeNotification object:change];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        //notification.alertBody
#warning trigger in app notification ui here for new conversation
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (LYRMessage *)messageFromRemoteNotification:(NSDictionary *)remoteNotification {
    LYRClient *layerClient = [CRConversationManager layerClient];
    
    // Fetch message object from LayerKit
    NSURL *messageURL = [NSURL URLWithString:[remoteNotification valueForKeyPath:@"layer.event_url"]];
    NSSet *messages = [layerClient messagesForIdentifiers:[NSSet setWithObject:messageURL]];
    return [[messages allObjects] firstObject];
}

@end
