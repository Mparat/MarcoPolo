//
//  MessageCell.h
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>

@interface MessageCell : UICollectionViewCell


-(void)configureCell:(LYRMessage *)message layerClient:(LYRClient *)client;


@end
