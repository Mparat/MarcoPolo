//
//  AppDelegate.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "HomepageTVC.h"
#import "AddressBookTVC.h"
#import "AddContacts.h"
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import <LayerKit/LayerKit.h>
#import "parseUser.h"
#import "LayerClientController.h"
#import "LATabBarController.h"
#import "FirstView.h"

@implementation AppDelegate

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize layerClientController = _layerClientController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    LYRClient *layerClient = [LYRClient clientWithAppID:[[NSUUID alloc] initWithUUIDString:@"fcfd9d64-25c5-11e4-90fa-fff20000031c"]];
    [layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Sucessfully connected to Layer!");
            for (int i = 1; i < 1000; i++) {
                printf("%d\n", i);
//                printf("register r%d(r_out[%d], wr_data, clock, w_enable[%d], reset);\n", i, i, i);
            }
        } else {
            NSLog(@"Failed connection to Layer with error: %@", error);
        }
    }];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    self.locationManager = [[LocationManagerController alloc] init];
    [self.locationManager launchLocationManager];
    
    self.layerClientController = [[LayerClientController alloc] initWithLayerClient:layerClient];
    self.layerClientController.locationManager = self.locationManager;
    [self.layerClientController initAPIManager];
    
    self.parseController = [[ParseController alloc] init];
    [self.parseController launchParse];
    
    [Parse setApplicationId:@"tdEggtacgTg3NFQwckCfs4Pb3D8oQV951J0wIzoo"
                  clientKey:@"MBBcfxg0nRsIds0xY6jFJbIdE8nM7uk7WJ5Tm7uv"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self checkCurrentUser];
    
//    // Checking if app is running iOS 8
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        // Register device for iOS8
//        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
//                                                                                             categories:nil];
//        [application registerUserNotificationSettings:notificationSettings];
//        [application registerForRemoteNotifications];
//    } else {
//        // Register device for iOS7
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
//    }
    
    return YES;
}

-(void)checkCurrentUser
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![PFUser currentUser]) {
        [self.window setRootViewController:[self navigationController]];
    }
    else{
        self.parseController.signedInUser = [PFUser currentUser];
        [self loginSuccessful];
    }
    [self.window makeKeyAndVisible];
}

-(UINavigationController *)navigationController
{
    FirstView *firstView = [[FirstView alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:firstView];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSError *error;
    BOOL success = [self.layerClientController.layerClient updateRemoteNotificationDeviceToken:deviceToken error:&error];
    if (success) {
        NSLog(@"Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Application failed to register for remote notifications with error %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    BOOL success = [self.layerClientController.layerClient synchronizeWithRemoteNotification:userInfo completion:^(UIBackgroundFetchResult fetchResult, NSError *error) {
        if (!error) {
            NSLog (@"Layer Client finished background sycn");
        }
        completionHandler(fetchResult);
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)loginSuccessful
{
    PFUser *user = [PFUser currentUser];
    NSString *email = user.email;
    NSString *password = user.password;

    if (!self.layerClientController.apiManager.layerClient.authenticatedUserID) {
        [self.layerClientController.apiManager authenticateWithEmail:email password:password completion:^(PFUser *user, NSError *error) {
            if (!error) {
                LATabBarController *tabBarController = [LATabBarController initWithParseController:self.parseController locationManager:self.locationManager clientController:self.layerClientController];
//                [tabBarController loadParseUsers];
                [self.window setRootViewController:tabBarController];
            }
        }];
    }
    else {
        LATabBarController *tabBarController = [LATabBarController initWithParseController:self.parseController locationManager:self.locationManager clientController:self.layerClientController];
//        [tabBarController loadParseUsers];
        [self.window setRootViewController:tabBarController];
    }
}

@end
