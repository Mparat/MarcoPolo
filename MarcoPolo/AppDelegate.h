//
//  AppDelegate.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "LayerClientController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) LayerClientController *layerClientController;


-(UINavigationController *)navigationController;
-(void)loginSuccessful;
-(void)checkCurrentUser;

@end
