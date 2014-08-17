//
//  AddressBookTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/17/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "LayerAPIManager.h"
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"


@interface AddressBookTVC : UITableViewController
{
    NSMutableArray *selectedContacts;
    UIView *footer;
    UILabel *selectedContactsLabel;
    UIButton *send;
    UIButton *addNew;
    UIBarButtonItem *cancelSelectionButton;
    UIButton *button;
    BOOL checked;
}
-(id)initWithStyle:(UITableViewStyle)style me:(User *)me;

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) LayerAPIManager *apiManager;

@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic) CFArrayRef contacts;

@property (nonatomic, strong) User *me;

@end