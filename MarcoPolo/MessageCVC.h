//
//  MessageCVC.h
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import "Contact.h"
#import "LayerAPIManager.h"
#import <LayerKit/LayerKit.h>


@interface MessageCVC : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout apiManager:(LayerAPIManager *)apiManager;


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) LayerAPIManager *apiManager;

@property (nonatomic, strong) LYRConversation *conversation;
@property (nonatomic, strong) NSOrderedSet *messages;
@property (nonatomic, strong) Contact *recipient;
@property (nonatomic, strong) User *me;

-(void)fetchMessages;

//- (id)init;

@end
