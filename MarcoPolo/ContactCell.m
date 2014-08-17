//
//  ContactCell.m
//  LocationsApp
//
//  Created by Meera Parat on 6/25/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "ContactCell.h"

@interface ContactCell ()

//@property (nonatomic, strong) UILabel

@end

@implementation ContactCell

@synthesize contact = _contact;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)initWithContact:(Contact *)friend
{
    [self placeNames:friend];
}

-(void)placeNames:(Contact *)friend
{
    self.contact = friend;
    [self.textLabel setText:[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]];
    self.textLabel.font = [UIFont fontWithName:@"AvenirNext" size:17];
    UIImageView *unselected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnselectedCircle"]];
    unselected.frame = CGRectMake(256+20, 19.5, 29, 29);
    [self addSubview:unselected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
