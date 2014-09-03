//
//  OptionsView.h
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
#import "LocationManagerController.h"
#import "LayerAPIManager.h"
#import "ParseController.h"
#import "Contact.h"
#import "MapViewAnnotation.h"
#import "User.h"

@interface OptionsView : UIViewController

-(id)initWithConversation:(LYRConversation *)conversation;

@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) LYRMessage *message;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) LayerAPIManager *apiManager;
@property (nonatomic, strong) LYRMessage *theirLastMessage;

@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) User *me;

@property (nonatomic, strong) MapViewAnnotation *annotation;


@end
