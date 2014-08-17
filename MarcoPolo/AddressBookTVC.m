//
//  AddressBookTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/17/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

/*
 at login, do the comparison and store the array of phone numbers in a nsuserdefault, code it, keyed archive, etc.....
 */


#import "AddressBookTVC.h"
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import "AddContacts.h"
#import "HomepageTVC.h"
#import "SearchCell.h"
#import "Contact.h"
#import "ContactCell.h"
#import "SettingsTVC.h"

@interface AddressBookTVC () <UISearchDisplayDelegate, UISearchBarDelegate, MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation AddressBookTVC

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize addressBook = _addressBook;
@synthesize contacts = _contacts;
@synthesize me = _me;


#define contactCell @"contactCell"

- (id)initWithStyle:(UITableViewStyle)style me:(User *)me
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.me = me;
        footer = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self addSearchBar];
    [self addRecipientsView];
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:contactCell];
    selectedContacts = [NSMutableArray array];
    button = [UIButton buttonWithType:UIButtonTypeCustom];

    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self addNavBar];
    [self placeButtonForEmptyController];

    self.clearsSelectionOnViewWillAppear = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: self.me.userID];
    if ([self.me.friends count] != 0) {
        self.me.friends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreate
}

-(void)placeButtonForEmptyController
{
    [button setFrame:CGRectMake(self.tableView.frame.size.width/2 - 240/4, self.tableView.frame.size.height/2 - 74, 120, 120)];
    [button setImage:[UIImage imageNamed:@"AddContacts"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    if ([self.me.friends count] == 0) {
        [self.tableView addSubview:button];
    }
    else{
        [button removeFromSuperview];
    }
}


-(void)addNavBar
{
    [self addPlusButton];
    
    UIButton *settings = [[UIButton alloc] init];
    [settings setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(toSettings) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [settings setFrame:CGRectMake(-10, 0, 44, 44)];
    [view addSubview:settings];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSForegroundColorAttributeName : [UIFont fontWithName:@"AvenirNext" size:20.0]};
    
    NSDictionary *text = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor whiteColor], NSForegroundColorAttributeName,
                          [UIFont fontWithName:@"AvenirNext" size:20.0], NSForegroundColorAttributeName,
                          nil];
    self.navigationController.navigationBar.titleTextAttributes = text;
    self.navigationItem.title = [NSString stringWithFormat:@"My Friends"];
}


-(void)addSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    CGPoint offset = CGPointMake(0, self.view.frame.size.height);
    //    CGPoint offset = CGPointMake(0, 30); // height offset is the height of the navigationBar --> decided from the logout button height.
    self.tableView.contentOffset = offset;
    self.searchResults = [NSMutableArray array];
}

#pragma mark - Search Bar Delegate controls
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //        [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}

-(void)filterResults:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"firstName beginswith[cd] %@", searchTerm];
    NSMutableArray *filter1 = [NSMutableArray arrayWithArray:self.me.friends];
    [filter1 filterUsingPredicate:predicate1]; // filtered Names
    
    [self.searchResults addObjectsFromArray:filter1];
}

-(void)toSettings
{
    SettingsTVC *settings = [[SettingsTVC alloc] init];
    settings.apiManager = self.apiManager;
    [self.navigationController pushViewController:settings animated:YES];
}

-(void)addFriends
{
    AddContacts *add = [[AddContacts alloc] init];
    add.parseController = self.parseController;
    add.me = self.me;
    
    [self.navigationController pushViewController:add animated:YES];
}

-(void)addRecipientsView
{
    footer.frame = CGRectMake(0, self.view.frame.size.height-100+11, self.view.frame.size.width, 60);
    footer.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:192.0/255.0 blue:124.0/255.0 alpha:1.0];
    send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    send.frame = CGRectMake(251, 0, 58, 58);
    [send setBackgroundImage:[UIImage imageNamed:@"AskCell"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAskMessage) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:send];
    
    selectedContactsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 250, 20)];
    selectedContactsLabel.font = [UIFont fontWithName:@"AvenirNext" size:17];
    selectedContactsLabel.textColor = [UIColor whiteColor];
    selectedContactsLabel.text = @"";
    [footer addSubview:selectedContactsLabel];
    
    UIButton *cancelSelection = [[UIButton alloc] initWithFrame:CGRectMake(253, 33, 60, 20)];
    [cancelSelection setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelSelection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelSelection.titleLabel.font = [UIFont fontWithName:@"AvenirNext" size:17];
    [cancelSelection addTarget:self action:@selector(cancelSelection) forControlEvents:UIControlEventTouchUpInside];
    
    cancelSelectionButton = [[UIBarButtonItem alloc] initWithCustomView:cancelSelection];
}

-(void)sendAskMessage
{
    Contact *sender = [[Contact alloc] init];
    sender.userID = self.me.userID;
    sender.firstName = self.me.firstName;
    sender.lastName = self.me.lastName;
    [selectedContacts addObject:sender];
    NSArray *allParticipants = [NSArray arrayWithArray:selectedContacts];
    [self.apiManager sendAskMessageToRecipients:[self createParticipantDict:allParticipants]];
    [selectedContacts removeObject:sender];
    [self cancelSelection];
}

-(void)cancelSelection
{
    NSArray *paths = [NSArray arrayWithArray:[self.tableView indexPathsForSelectedRows]];
    int count = (int)[selectedContacts count];
    
    for (int i = 0; i < count; i++) {
        [self.tableView deselectRowAtIndexPath:[paths objectAtIndex:i] animated:NO];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[paths objectAtIndex:i]];
        ((ContactCell *)cell).accessoryView = nil;
        [cell setBackgroundColor: [UIColor whiteColor]];
        [selectedContacts removeObject:((ContactCell *)cell).contact];
    }
    [footer removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    selectedContactsLabel.text = @"";
    
    [self addPlusButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchResultsTableView){
        return [self.searchResults count];
    }
    else{
        return [self.me.friends count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCell];
    cell = nil;
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)path inTableView:(UITableView *)tableView
{
    Contact *friend = [[Contact alloc] init];
    if (tableView == self.searchController.searchResultsTableView){
        friend = [self.searchResults objectAtIndex:path.row];
    }
    else{
        friend = [self.me.friends objectAtIndex:path.row];
    }
    [(ContactCell *)cell initWithContact:friend];
    cell.contact = friend;
    [self configureSwipeViews:cell];
}

-(NSMutableDictionary *)createParticipantDict:(NSArray *)contacts
{
    NSMutableDictionary *everyone = [NSMutableDictionary dictionary];
    for (int i = 0; i < [contacts count]; i++) {
        Contact *temp = (Contact *)[contacts objectAtIndex:i];
        NSArray *arr = [NSArray arrayWithObjects:temp.userID, temp.firstName, temp.lastName, nil];
        [everyone setValue:arr forKey:(NSString *)temp.userID];
    }
    
    return everyone;
}

-(void)configureSwipeViews:(ContactCell *)cell
{
    UIView *askView = [self viewWithImageName:@"AskCell"];
    UIColor *greenColor = [UIColor colorWithRed:42.0 / 255.0 green:192.0 / 255.0 blue:124.0 / 255.0 alpha:1.0];
    
    UIView *tellView = [self viewWithImageName:@"TellCell"];
    UIColor *purpleColor = [UIColor colorWithRed:177.0 / 255.0 green:74.0 / 255.0 blue:223.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
        [cell swipeToOriginWithCompletion:^{
            Contact *sender = [[Contact alloc] init];
            sender.firstName = self.me.firstName;
            sender.lastName = self.me.lastName;
            sender.userID = self.me.userID;
            NSArray *allParticipants = [NSArray arrayWithObjects:((ContactCell *)cell).contact, sender, nil];
            [self.apiManager sendAskMessageToRecipients:[self createParticipantDict:allParticipants]];
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:purpleColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        [cell swipeToOriginWithCompletion:^{
            Contact *sender = [[Contact alloc] init];
            sender.firstName = self.me.firstName;
            sender.lastName = self.me.lastName;
            sender.userID = self.me.userID;
            NSArray *allParticipants = [NSArray arrayWithObjects:((ContactCell *)cell).contact, sender, nil];
            [self.apiManager sendTellMessageToRecipients:[self createParticipantDict:allParticipants]];
        }];
    }];
    
    cell.defaultColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    cell.firstTrigger = 0.25;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCircle"]];
    ((ContactCell *)cell).accessoryView = selected;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (((ContactCell *)cell).accessoryView == nil) {
        UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCircle"]];
        ((ContactCell *)cell).accessoryView = selected;
        [cell setBackgroundColor: [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        [selectedContacts addObject:((ContactCell *)cell).contact];
        if ([selectedContacts count] == 1) {
            selectedContactsLabel.text = [NSString stringWithFormat:@"%@ %@", selectedContactsLabel.text, ((Contact *)[selectedContacts lastObject]).firstName];
        }
        if ([selectedContacts count] > 1) {
            selectedContactsLabel.text = [NSString stringWithFormat:@"%@, %@", selectedContactsLabel.text, ((Contact *)[selectedContacts lastObject]).firstName];
        }
    }
    else{
        ((ContactCell *)cell).accessoryView = nil;
        [selectedContacts removeObject:((ContactCell *)cell).contact];
        [cell setBackgroundColor: [UIColor whiteColor]];
        selectedContactsLabel.text = @"";
        for (int i = 0; i < [selectedContacts count]; i++) {
            if (i == 0) {
                selectedContactsLabel.text = [NSString stringWithFormat:@"%@ %@", selectedContactsLabel.text, ((Contact *)[selectedContacts objectAtIndex:i]).firstName];
            }
            if (i > 0) {
                selectedContactsLabel.text = [NSString stringWithFormat:@"%@, %@", selectedContactsLabel.text, ((Contact *)[selectedContacts objectAtIndex:i]).firstName];
            }
        }
    }
    
    //    NSIndexPath *path = [tableView indexPathForSelectedRow];
    if ([selectedContacts count] == 0) { // if (path)
        NSLog(@"no cell is selected");
        [footer removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        selectedContactsLabel.text = @"";
        [self addPlusButton];
        
    }
    else{
        //        [self.view addSubview:footer];
        [self.navigationController.view addSubview:footer];
        self.navigationItem.rightBarButtonItem = cancelSelectionButton;
    }
}

-(void)addPlusButton
{
    addNew = [[UIButton alloc] init];
    [addNew setImage:[UIImage imageNamed:@"AddNew"] forState:UIControlStateNormal];
    [addNew addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    [addNew setFrame:CGRectMake(15, 0, 58, 58)];
    [view2 addSubview:addNew];
    
    UIBarButtonItem *addNewButton = [[UIBarButtonItem alloc] initWithCustomView:view2];
    self.navigationItem.rightBarButtonItem = addNewButton;
}


@end