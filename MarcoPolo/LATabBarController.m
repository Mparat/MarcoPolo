//
//  LATabBarController.m
//  LocationsApp
//
//  Created by Meera Parat on 8/7/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LATabBarController.h"
#import "Contact.h"
#import "HomepageTVC.h"
#import "AddressBookTVC.h"

@interface LATabBarController ()

@end

@implementation LATabBarController

@synthesize parseController = _parseController;
@synthesize locationManager = _locationManager;

+(instancetype)initWithParseController:(ParseController *)parseController locationManager:(LocationManagerController *)locationManager clientController:(LayerClientController *)layerClientController
{
    NSParameterAssert(parseController);
    NSParameterAssert(locationManager);
    NSParameterAssert(layerClientController);
    return [[self alloc] initWithParseController:parseController locationManager:locationManager layerClientController:layerClientController];
}

- (id)initWithParseController:(ParseController *)parseController locationManager:(LocationManagerController *)locationManager layerClientController:(LayerClientController *)layerClientController
{
    self = [super init];
    if (self) {
        _parseController = parseController;
        _locationManager = locationManager;
        _layerClientController = layerClientController;
        
        [self setUpViewControllers];
    }
    return self;
}

- (void)setUpViewControllers
{
    [self loadParseUsers];
    User *me = [[User alloc] init];
    me.firstName = [self.parseController.signedInUser objectForKey:@"firstName"];
    me.lastName = [self.parseController.signedInUser objectForKey:@"lastName"];
    me.username = self.parseController.signedInUser.username; //email
    me.userID = self.parseController.signedInUser.objectId;
    
    NSUserDefaults *friends = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [friends objectForKey:me.userID];
    NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    me.friends = [NSMutableArray arrayWithArray:array1];
    
    HomepageTVC *homepage = [HomepageTVC initWithParseController:self.parseController locationManager:self.locationManager apiManager:self.layerClientController.apiManager me:me];
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:homepage];
    
//    AddressBookTVC *contacts = [AddressBookTVC initWithParseController:self.parseController locationManager:self.locationManager apiManager:self.layerClientController.apiManager me:me];
    AddressBookTVC *contacts = [[AddressBookTVC alloc] initWithStyle:UITableViewStylePlain me:me];
    contacts.parseController = self.parseController;
    contacts.locationManager = self.locationManager;
    contacts.apiManager = self.layerClientController.apiManager;
    UINavigationController *controller2 = [[UINavigationController alloc] initWithRootViewController:contacts];
    
    NSArray *controllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    [self setViewControllers:controllers];
    
    UIImage *unselectedContacts = [UIImage imageNamed:@"UnselectedContacts"];
    UIImage *selectedContacts = [UIImage imageNamed:@"SelectedContacts"];
    UIImage *unselectedMessages = [UIImage imageNamed:@"UnselectedMessages"];
    UIImage *selectedMessages = [UIImage imageNamed:@"SelectedMessages"];
    UIColor *red = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    
    selectedMessages = [selectedMessages imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller1.tabBarController.tabBar.selectedImageTintColor = red;
    
    selectedContacts = [selectedContacts imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller2.tabBarController.tabBar.selectedImageTintColor = red;
    
    UITabBarItem *chats = [[UITabBarItem alloc] initWithTitle:@"Messages" image:unselectedMessages selectedImage:selectedMessages];
   
    UITabBarItem *addNew = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:unselectedContacts selectedImage:selectedContacts];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor grayColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"AvenirNext" size:0.0], NSForegroundColorAttributeName,
      nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      red, NSForegroundColorAttributeName,
      [UIFont fontWithName:@"AvenirNext" size:0.0], NSForegroundColorAttributeName,
      nil] forState:UIControlStateSelected];
    
    
    [controller1 setTabBarItem:chats];
    [controller2 setTabBarItem:addNew];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadParseUsers
{
    self.parseController.signedInUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"]; //email address --> use to send messages, use as user ID for app
    [query whereKey:@"username" notEqualTo:self.parseController.signedInUser.username];

    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        for (int i = 0; i < [users count]; i++) {
            NSString *username = [[users objectAtIndex:i] objectForKey:@"username"];
            NSString *firstName = [[users objectAtIndex:i] objectForKey:@"firstName"];
            NSString *lastName = [[users objectAtIndex:i] objectForKey:@"lastName"];
            NSString *userID = ((PFUser *)[users objectAtIndex:i]).objectId;
            Contact *person = [[Contact alloc] init];
            person.userID = userID;
            person.username = username;
            person.firstName = firstName;
            person.lastName = lastName;
            [self.parseController.parseUsers addObject:person];
        }
    }];

}

-(void)initViews
{

}


@end
