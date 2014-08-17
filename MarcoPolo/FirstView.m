//
//  FirstView.m
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "FirstView.h"
#import "LoginView.h"
#import "Signup.h"

@interface FirstView ()

@end

@implementation FirstView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background0"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background0"]];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBarHidden = YES;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(25, 300, 270, 45)];
    [loginButton setImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(toLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton setFrame:CGRectMake(25, 365, 270, 45)];
    [signupButton setImage:[UIImage imageNamed:@"SignupButton"] forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(toSignupView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toLoginView
{
    LoginView *loginView = [[LoginView alloc] init];
    [self.navigationController presentViewController:loginView animated:YES completion:^{
        //
    }];
}

-(void)toSignupView
{
//    SignupView *signupView = [[SignupView alloc] init];
    Signup *signupView = [[Signup alloc] init];

    [self.navigationController presentViewController:signupView animated:YES completion:^{
        //
    }];
}


@end
