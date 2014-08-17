//
//  LoginView.h
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseController.h"
#import "LocationManagerController.h"
#import "LayerAPIManager.h"


@interface LoginView : UIViewController <PFLogInViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) NSMutableArray *parseUserNumbers;
@property (nonatomic, strong) NSMutableArray *parseUserUsernames;

@property (nonatomic, strong) PFLogInViewController *parseLoginVC;
@property (nonatomic, strong) PFLogInView *loginView;

@property (nonatomic, strong) LocationManagerController *locationManager;

@end
