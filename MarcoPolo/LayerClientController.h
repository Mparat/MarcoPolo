//
//  LayerClientController.h
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>
#import "LayerAPIManager.h"
#import "LocationManagerController.h"


@interface LayerClientController : NSObject <LYRClientDelegate>

@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) LayerAPIManager *apiManager;
@property (nonatomic, strong) LocationManagerController *locationManager;

-(id)initWithLayerClient:(LYRClient *)client;

-(void)initAPIManager;


@end
