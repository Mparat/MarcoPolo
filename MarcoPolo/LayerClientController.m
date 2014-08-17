//
//  LayerClientController.m
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LayerClientController.h"

@implementation LayerClientController

@synthesize layerClient = _layerClient;
@synthesize apiManager = _apiManager;


-(id)initWithLayerClient:(LYRClient *)client
{
    self = [super init];
    if (self) {
        self.layerClient = client;
        self.layerClient.delegate = self;
    }
    return self;
}

-(void)initAPIManager
{
    self.apiManager = [[LayerAPIManager alloc] initWithLayerClient:self.layerClient];
    self.apiManager.locationManager = self.locationManager;
}

#pragma mark Layer Client delegate methods

-(void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Layer Client did recieve authentication challenge");
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Layer Client did authenticate as userID");
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    NSLog(@"Layer Client did deauthenticate");
}

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes
{
    NSLog(@"Layer Client did finish sychronization");
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error
{
    NSLog(@"Layer Client did fail synchronization with error: %@", error);
}

@end
