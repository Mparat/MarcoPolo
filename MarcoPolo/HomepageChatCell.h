//
//  HomepageChatCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "User.h"
#import "MCSwipeTableViewCell.h"
#import "Contact.h"
#import "LocationManagerController.h"
#import "LayerAPIManager.h"

@interface HomepageChatCell : MCSwipeTableViewCell 

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) LYRMessage *message;
@property (nonatomic, strong) LYRMessage *theirLastMessage;

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) LayerAPIManager *apiManager;

-(void)createCellWith:(LYRConversation *)conversation person:(NSArray *)person layerClient:(LYRClient *)client;
-(void)createGroupCellWithNames:(NSArray *)firstNames conversation:(LYRConversation *)conversation layerClient:(LYRClient *)client;
-(void)configureExpandedCell:(LYRConversation *)conversation person:(NSArray *)person layerClient:(LYRClient *)client;


@end
