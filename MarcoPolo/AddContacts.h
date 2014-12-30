//
//  AddContacts.h
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ParseController.h"

@interface AddContacts : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) User *me;

@property (nonatomic, strong) NSString *className;


@end
