//
//  AddContacts.m
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AddContacts.h"
#import "SearchCell.h"
#import "HomepageTVC.h"
#import "AppDelegate.h"
#import "AddressBookTVC.h"

@interface AddContacts () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@interface AddContacts ()

@end

@implementation AddContacts

@synthesize parseController = _parseController;
@synthesize className = _className;
@synthesize me = _me;


#define searchCell @"searchCell"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = @"_User";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self.tableView setDelegate:self];
    self.tableView.rowHeight = 68.0;
    
    [self.tableView reloadData];
    [self.tableView registerClass:[SearchCell class] forCellReuseIdentifier:searchCell];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    self.searchResults = [NSMutableArray array];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addNavBar
{
    self.navigationItem.title = [NSString stringWithFormat:@"Add Friends"];
    UIColor *purpleColor = [UIColor colorWithRed:177.0 / 255.0 green:74.0 / 255.0 blue:223.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = purpleColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


-(void)filterResults:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"firstName beginswith[cd] %@", searchTerm];
    NSMutableArray *filter1 = [NSMutableArray arrayWithArray:self.parseController.parseUsers];
    [filter1 filterUsingPredicate:predicate1]; // filtered users w/ searched firstNames of all parse users

    [self.searchResults addObjectsFromArray:filter1]; //array of "parseUsers" w/ firstName, lastName, username
}

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
        [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchResults count] == 0){
        return 0;
    }
    else
        return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    cell = nil;
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)configureCell:(SearchCell *)cell atIndexPath:(NSIndexPath *)path
{
    // configure all  cells with parseUser
    Contact *user = [self.searchResults objectAtIndex:path.row];
    [(SearchCell *)cell initWithContact:user];
    cell.person = user;
    
    // check the current username result w/ all the usernames in your friendsArray
    // if the cell in question is a user that you are already friends with, then marked them w/ a checmark.
    for (int i = 0; i < [self.me.friends count]; i++) {
        NSString *searchUsername = user.username;
        NSString *friendUsername = ((Contact *)[self.me.friends objectAtIndex:i]).username;

        if ([searchUsername isEqualToString:friendUsername]) {
            UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCircle"]];
            ((SearchCell *)cell).accessoryView = selected;
            [cell setBackgroundColor: [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCircle"]];
    ((SearchCell *)cell).accessoryView = selected;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    if (((SearchCell *)cell).accessoryView == nil) {
        UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCircle"]];
        ((SearchCell *)cell).accessoryView = selected;
        [cell setBackgroundColor: [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        
        [self.me.friends addObject:((SearchCell *)cell).person];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.friends];
        [defaults setObject:data forKey: [PFUser currentUser].objectId];
        [defaults synchronize];
    }
    else{
        ((SearchCell *)cell).accessoryView = nil;
        [self deselectCell:cell];
        [cell setBackgroundColor: [UIColor whiteColor]];
        [self.me.friends removeObject:((SearchCell *)cell).person];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.friends];
        [defaults setObject:data forKey: [PFUser currentUser].objectId];
        [defaults synchronize];
//        [self.tableView reloadData];
    }
}

-(void)deselectCell:(UITableViewCell *)cell
{
    UIImageView *unselected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnselectedNewContact"]];
    unselected.frame = CGRectMake(256+20, 19, 29, 29);
    [cell addSubview:unselected];
}


@end
