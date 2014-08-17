//
//  LATabBarController.h
//  LocationsApp
//
//  Created by Meera Parat on 8/7/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseController.h"
#import "LayerClientController.h"
#import "LocationManagerController.h"

@interface LATabBarController : UITabBarController

@property (nonatomic, strong) ParseController *parseController;
@property(nonatomic, strong) LayerClientController *layerClientController;
@property (nonatomic, strong) LocationManagerController *locationManager;

-(void)loadParseUsers;
-(void)initViews;

+(instancetype)initWithParseController:(ParseController *)parseController locationManager:(LocationManagerController *)locationManager clientController:(LayerClientController *)layerClientController;


@end
