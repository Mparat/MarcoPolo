//
//  MapVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <LayerKit/LayerKit.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import "Contact.h"
#import "LayerAPIManager.h"

@interface MapVC : UIViewController 

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) User *me;

@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) LayerAPIManager *apiManager;
@property (nonatomic, strong) LYRMessage *theirLastMessage;


@end
