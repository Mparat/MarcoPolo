//
//  SearchCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "parseUser.h"
#import "Contact.h"

@interface SearchCell : UITableViewCell

@property (nonatomic, strong) Contact *person;

-(void)initWithContact:(Contact *)user;


@end
