//
//  SearchCell.m
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@end


@implementation SearchCell

@synthesize person = _person;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithContact:(Contact *)user
{
    [self placeNames:user];
}

-(void)placeNames:(Contact *)user
{
    [self.textLabel setText:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
    self.textLabel.font = [UIFont fontWithName:@"AvenirNext" size:17];
    UIImageView *unselected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnselectedNewContact"]];
    unselected.frame = CGRectMake(256+20, 19, 29, 29);
    [self addSubview:unselected];
}


@end
