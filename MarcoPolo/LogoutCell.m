//
//  LogoutCell.m
//  LocationsApp
//
//  Created by Meera Parat on 7/15/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LogoutCell.h"

@interface LogoutCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation LogoutCell

@synthesize label = _label;


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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)placeSubviewsForCell
{
    [self initCell];
}

-(void)initCell
{
    self.textLabel.text = @"Logout";
    self.textLabel.font = [UIFont fontWithName:@"AvenirNext" size:17];

//    self.label = [[UILabel alloc] init];
//    self.label.text = @"Logout";
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName, nil];
//    self.label.frame = CGRectMake(self.label.frame.origin.x,
//                                 self.label.frame.origin.y,
//                                 [self.label.text sizeWithAttributes:dict].width,
//                                 [self.label.text sizeWithAttributes:dict].height);
//    
//    self.label.frame = CGRectMake(70, 20, self.label.frame.size.width, 20);
//    self.label.font = [UIFont fontWithName:@"Helvetica" size:16];
//    self.label.textColor = [UIColor blackColor];
//    [self addSubview:self.label];
}

@end
