//
//  Signup.m
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "Signup.h"
#import "AppDelegate.h"

@interface Signup ()

@end

@implementation Signup

@synthesize parseSignupVC;
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background2"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self configureViews];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureViews
{
    parseSignupVC = [[PFSignUpViewController alloc] init];
    [parseSignupVC setDelegate:self];
    [parseSignupVC setFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton];

    
    email = [[UITextField alloc] init];
    [email setFrame:CGRectMake(25, 390/2, 270, 45)];
    [email setPlaceholder:@"Email"];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.textAlignment = NSTextAlignmentLeft;
    [email setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [email setBackgroundColor:[UIColor whiteColor]];
    [email setBorderStyle:UITextBorderStyleRoundedRect];
    email.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    email.delegate = self;
    [self.view addSubview:email];
    
    password = [[UITextField alloc] init];
    [password setFrame:CGRectMake(25, 530/2, 270, 45)];
    [password setPlaceholder:@"Password"];
    password.textAlignment = NSTextAlignmentLeft;
    password.secureTextEntry = YES;
    [password setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [password setBackgroundColor:[UIColor whiteColor]];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    password.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    password.delegate = self;
    [self.view addSubview:password];
    
    firstName = [[UITextField alloc] init];
    [firstName setFrame:CGRectMake(25, 125, 120, 45)];
    [firstName setPlaceholder:@"First Name"];
    firstName.textAlignment = NSTextAlignmentLeft;
    [firstName setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [firstName setBackgroundColor:[UIColor whiteColor]];
    [firstName setBorderStyle:UITextBorderStyleRoundedRect];
    firstName.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    firstName.delegate = self;
    [self.view addSubview:firstName];
    [firstName becomeFirstResponder];

    
    lastName = [[UITextField alloc] init];
    [lastName setFrame:CGRectMake(350/2, 125, 120, 45)];
    [lastName setPlaceholder:@"Last Name"];
    lastName.textAlignment = NSTextAlignmentLeft;
    [lastName setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [lastName setBackgroundColor:[UIColor whiteColor]];
    [lastName setBorderStyle:UITextBorderStyleRoundedRect];
    lastName.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    lastName.delegate = self;
    [self.view addSubview:lastName];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(25, 375, 270, 45)];
    [doneButton addTarget:self action:@selector(signUpViewController:shouldBeginSignUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:[UIImage imageNamed:@"CancelLoginSignup"] forState:UIControlStateNormal];
    [dismissButton setFrame:CGRectMake(25, 31, 20, 20)];
    [dismissButton addTarget:self action:@selector(signUpViewControllerDidCancelSignUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];

}


#pragma mark - Parse Sign up delegate methods

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    if (firstName.text.length == 0 || lastName.text.length == 0 || email.text.length == 0 || password.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure to fill out all fields"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    if (![self isValidEmailAddress:email.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Invalid email"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:email.text];
    NSArray *array = [query findObjects];
    if ([array count] > 1) {
        [[[UIAlertView alloc] initWithTitle:@"Account Exists"
                                    message:@"An account with this email address already exists"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    else{
        PFUser *newUser = [PFUser user];
        newUser.username = email.text;
        newUser.email = email.text;
        newUser.password = password.text;
        [newUser setObject:firstName.text forKey:@"firstName"];
        [newUser setObject:lastName.text forKey:@"lastName"];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self signUpViewController:parseSignupVC didSignUpUser:newUser];
            }
            else{
                [self signUpViewController:parseSignupVC didFailToSignUpWithError:error];
            }
        }];
        return YES;
    }
}

- (BOOL)isValidEmailAddress:(NSString *)address
{
    NSString *regex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:address];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"Sign up successful");
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] checkCurrentUser];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Sign up failed with error: %@", error);
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User cancelled sign up");
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] checkCurrentUser];
}

@end
