//
//  MessageCVC.m
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageCVC.h"
#import "MessageCell.h"
#import "OptionsView.h"

@interface MessageCVC ()

@end

@implementation MessageCVC

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize recipient = _recipient;
@synthesize me = _me;

#define messageCell @"messageCell"


-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout apiManager:(LayerAPIManager *)apiManager
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.apiManager = apiManager;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                 collectionViewLayout:layout];

        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundView = [[UIView alloc] init];
        [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)]];
        
        
        self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 20, 0);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceVertical = TRUE;
        self.collectionView.bounces = TRUE;
        self.collectionView.accessibilityLabel = @"collectionView";
        [self.view addSubview:self.collectionView];
        self.clearsSelectionOnViewWillAppear = YES;
        [self.collectionView registerClass:[MessageCell class] forCellWithReuseIdentifier:messageCell];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLayerObjectsDidChangeNotification:)
                                                     name:LYRClientObjectsDidChangeNotification object:self.apiManager.layerClient];
        [self.collectionView reloadData];
//        [self scrollToBottomofCollectionView];
        
    }
    return self;
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

- (void) didReceiveLayerObjectsDidChangeNotification:(NSNotification *)notification;
{
    [self fetchMessages];
    [self.collectionView reloadData];
    [self.textField resignFirstResponder];
    [self.tabBarController.tabBar setHidden:YES];
    [self scrollToBottomofCollectionView];
}

-(void)addNavBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSArray *names = [self.apiManager groupNameFromConversation:self.conversation];
    NSString *title = [NSString stringWithFormat:@"%@", [names objectAtIndex:0]];;
    for (int i = 1 ; i < [names count]; i++) {
        title = [NSString stringWithFormat:@"%@, %@", title, [names objectAtIndex:i]];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@", title];
}

-(void)initializeTextField
{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(-1, 523, self.view.frame.size.width+2, 46)];
    bottom.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    bottom.layer.borderColor = [[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1.0] CGColor];
    bottom.layer.borderWidth = 0.5f;
    [self.view addSubview:bottom];
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = [NSString stringWithFormat:@"Message"];
    [bottom addSubview:self.textField];
    self.textField.frame = CGRectMake(30+1, 8, 225, 29);
    self.textField.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//    self.textField.layer.borderWidth = 1.0f;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.textField.textAlignment = NSTextAlignmentNatural;
    self.textField.delegate = self;
    
    UIButton *send = [[UIButton alloc] init];
    [bottom addSubview:send];
    send.frame = CGRectMake(262.5+1, 12.5, 50, 20);
    [send setTitle:@"Send" forState:UIControlStateNormal];
//    send.titleLabel.text = @"Send";
//    send.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [send setTitleColor:[UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];

}


CGSize cellSizeForPart(LYRMessagePart *part, CGFloat width)
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize itemSize;
    
    //If Message Part is plain text...
    if ([part.MIMEType isEqualToString:@"text/plain"]) {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width * 0.70, 0)];
        textView.text = [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
        textView.font = [UIFont fontWithName:@"AvenirNext" size:16];
        [textView sizeToFit];
        itemSize = CGSizeMake(textView.frame.size.width + 25, textView.frame.size.height + 10);
    }
    
    if (30 > itemSize.height) {
        itemSize = CGSizeMake(rect.size.width, 30);
    }
    
    return itemSize;
}

-(void)sendText
{
    [self.apiManager sendTextMessage:self.textField.text inConversation:self.conversation];
    self.textField.text = nil;
//    [self viewWillAppear:YES];
//    [self fetchMessages];
//    [self.collectionView reloadData];
//    [self scrollToBottomofCollectionView];

}

//- (void) animations
//{
//    [UIView animateWithDuration:1.0f animations:^{
//        self.textField.frame = CGRectMake(100, 100, 100, 100);
//    }];
//    
//    [UIView animateWithDuration:1.0f animations:^{
//        //
//    } completion:^(BOOL finished) {
//        //
//    }];
//    
//    [UIView animateWithDuration:1.0f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        //
//    } completion:^(BOOL finished) {
//        //
//    }];
//    
//}


// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:messageCell forIndexPath:indexPath];
    [self configureCell:(MessageCell *)cell atIndexPath:(NSIndexPath *)indexPath];
    return cell;
}

-(void)configureCell:(MessageCell *)cell atIndexPath:(NSIndexPath *)path
{
    LYRMessage *message = [self.messages objectAtIndex:path.section];
    if ([message.sentByUserID isEqual:self.apiManager.layerClient.authenticatedUserID]) {
        cell.frame = CGRectMake(self.collectionView.frame.size.width - cell.frame.size.width - 8, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    }
    else{
        cell.frame = CGRectMake(8, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    }

    [(MessageCell *)cell configureCell:message layerClient:self.apiManager.layerClient];
}


#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionViewContentSize
{
    return self.collectionViewLayout.collectionViewContentSize;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self fetchMessages];
    LYRMessage *message = [self.messages objectAtIndex:indexPath.section];
    LYRMessagePart *part = [message.parts objectAtIndex:1];
    return cellSizeForPart(part, self.view.frame.size.width);
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 8, 6, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.messages.count;
}



#pragma mark - TextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)fetchMessages
{
    if (self.messages) self.messages = nil;
    self.messages = [self.apiManager.layerClient messagesForConversation:self.conversation];
}

-(void)scrollToBottomofCollectionView
{
    NSInteger section = [self numberOfSectionsInCollectionView:self.collectionView] - 1;
    NSInteger item = [self collectionView:self.collectionView numberOfItemsInSection:section] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self fetchMessages];
    [self.collectionView reloadData];
    [self initializeTextField];
    [self addNavBar];
    [self scrollToBottomofCollectionView];

    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
    [self scrollToBottomofCollectionView];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

-(void)viewTouched
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

// This method will be called when the user touches on the tableView, at
// which point we will hide the keyboard (if open). This method is called
// because UITouchTableView.m calls nextResponder in its touch handler.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}



@end
