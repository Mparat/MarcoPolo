//
//  MapVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MapVC.h"
#import "OptionsView.h"

@interface MapVC ()

@end

@implementation MapVC // Map shows user + recipients at most recent location update and time of that update, hence, may not all be the same time, but it's watever time came with the location message object.

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize me = _me;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];

//    [self.view addSubview:[self.locationManager displayMap:self.view withAnnotation:[self.locationManager annotationFromMessage:self.theirLastMessage]]];
    [self.view addSubview:[self.locationManager displayMap:self.view withAnnotation:self.annotation]];

    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addNavBar
{
    NSArray *names = [self.apiManager groupNameFromConversation:self.conversation];
    NSString *title = [NSString stringWithFormat:@"%@", [names objectAtIndex:0]];;
    for (int i = 1 ; i < [names count]; i++) {
        title = [NSString stringWithFormat:@"%@, %@", title, [names objectAtIndex:i]];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@", title];
    

    UIColor *purpleColor = [UIColor colorWithRed:177.0 / 255.0 green:74.0 / 255.0 blue:223.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = purpleColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

@end
