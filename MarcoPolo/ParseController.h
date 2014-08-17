//
//  ParseController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/12/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@class ParseController;

@protocol ParseControllerDelegate <NSObject>

@end


@interface ParseController : NSObject

@property (nonatomic, weak) id<ParseControllerDelegate> delegate;
@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) NSMutableArray *parseUsers;

-(void)launchParse;

@end