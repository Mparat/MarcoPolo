//
//  SettingsTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 7/15/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
#import "LayerAPIManager.h"


@interface SettingsTVC : UITableViewController

@property (nonatomic, strong) LayerAPIManager *apiManager;

@end
