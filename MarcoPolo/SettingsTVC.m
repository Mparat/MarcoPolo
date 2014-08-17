//
//  SettingsTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 7/15/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "SettingsTVC.h"
#import "AppDelegate.h"
#import "LogoutCell.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC

#define cellID @"cellID"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.tableView reloadData];
    [self.tableView registerClass:[LogoutCell class] forCellReuseIdentifier:cellID];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    NSDictionary *text = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor whiteColor], NSForegroundColorAttributeName,
                          [UIFont fontWithName:@"AvenirNext" size:20.0], NSForegroundColorAttributeName,
                          nil];
    self.navigationController.navigationBar.titleTextAttributes = text;
    self.navigationItem.title = [NSString stringWithFormat:@"Settings"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = nil;
    if (cell == nil) {
        cell = [[LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(LogoutCell *)cell atIndexPath:(NSIndexPath *)path
{
    [(LogoutCell *)cell placeSubviewsForCell];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.tableView.frame.size.width, 50)];
    header.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    UILabel *text = [[UILabel alloc] init];
    text.text = @"Account";
    text.font = [UIFont fontWithName:@"AvenirNext" size:17];
    text.frame = CGRectMake(15, 0, 100, 25);
    text.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
    [header addSubview:text];
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.apiManager logoutWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            self.tableView = nil;
            NSLog(@"Deauthenticated...");
            UINavigationController *controller = [(AppDelegate *) [[UIApplication sharedApplication] delegate] navigationController];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                //
            }];
            [self.navigationController presentViewController:controller animated:YES completion:^{
                //
            }];
        }
    }];
}

@end
