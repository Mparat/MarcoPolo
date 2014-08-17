//
//  LayerAPIManager.h
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
//#import "LocationManagerController.h"
@class LocationManagerController;

@interface LayerAPIManager : NSObject

@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) LocationManagerController *locationManager;

-(id)initWithLayerClient:(LYRClient *)client;


-(void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void(^)(PFUser *user, NSError *error))completion;
//- (BOOL)resumeSession:(LSSession *)session error:(NSError **)error;
- (void)logoutWithCompletion:(void(^)(BOOL success, NSError *error))completion;

-(void)sendAskMessageToRecipients:(NSMutableDictionary *)recipients;
-(void)sendTellMessageToRecipients:(NSMutableDictionary *)recipients;
-(void)sendTextMessage:(NSString *)text inConversation:(LYRConversation *)conversation;

-(NSMutableDictionary *)returnParticipantDictionary:(LYRConversation *)conversation;
-(NSMutableArray *)recipientUserIDs:(LYRConversation *)conversation;
-(NSArray *)personFromConversation:(LYRConversation *)conversation forUserID:(NSString *)uid;
-(NSArray *)personFromMessage:(LYRMessage *)message forUserID:(NSString *)uid;
-(NSMutableArray *)groupNameFromConversation:(LYRConversation *)conversation;

@end
