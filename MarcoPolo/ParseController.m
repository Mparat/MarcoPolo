//
//  ParseController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/12/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "ParseController.h"
#import "User.h"

@implementation ParseController

@synthesize signedInUser = _signedInUser;

-(void)launchParse
{
    self.parseUsers = [NSMutableArray array];
    return;
}


@end