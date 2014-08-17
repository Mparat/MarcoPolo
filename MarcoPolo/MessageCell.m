//
//  MessageCell.m
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius] CGPath];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x + 10, 11, self.frame.size.width, self.frame.size.height)];
        [self.label setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        [self.contentView addSubview:self.label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}


-(void)configureCell:(LYRMessage *)message layerClient:(LYRClient *)client
{
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    CGFloat width =  self.contentView.frame.size.width;
//    CGFloat height =  self.contentView.frame.size.height;

    UIView *view = [UIView new];
    view.layer.cornerRadius = 10;
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:view.layer.cornerRadius] CGPath];
    
    LYRMessagePart *part = [message.parts objectAtIndex:1];
    if ([message.sentByUserID isEqualToString:client.authenticatedUserID]) {
        view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:173.0/255.0 blue:186.0/255.0 alpha:1.0];
    }
    else
    {
        view.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    }

    [self.label setText:[NSString stringWithUTF8String:[part.data bytes]]];
    [self.label sizeToFit];
    self.backgroundView = view;


}


@end
