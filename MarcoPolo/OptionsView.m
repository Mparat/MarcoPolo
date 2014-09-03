//
//  OptionsView.m
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "OptionsView.h"
#import "MapVC.h"
#import "MessageCVC.h"
#import "UIImage+ImageEffects.h"


@interface OptionsView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) UIImage *image;

@end

@implementation OptionsView

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize me = _me;


-(id)initWithConversation:(LYRConversation *)conversation;
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image = [self capture];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 50)];
    [self updateImage];
    [self initButtons];
}

- (UIImage *) capture {
    UIGraphicsBeginImageContextWithOptions(self.parentViewController.view.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.parentViewController.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)updateImage
{
    UIImage *effectImage = nil;
    effectImage = [self.image applyDarkEffect];
    self.imageView.image = effectImage;
    [self.view addSubview:self.imageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initButtons
{
    UIButton *ask = [[UIButton alloc] initWithFrame:CGRectMake(21.5, 173, 78, 100)];
    [ask setBackgroundImage:[UIImage imageNamed:@"AskUnselected"] forState:UIControlStateNormal];
    [ask setBackgroundImage:[UIImage imageNamed:@"AskSelected"] forState:UIControlStateHighlighted];
    [ask addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ask];

    UIButton *tell = [[UIButton alloc] initWithFrame:CGRectMake(121, 173, 78, 100)];
    [tell setBackgroundImage:[UIImage imageNamed:@"TellUnselected"] forState:UIControlStateNormal];
    [tell setBackgroundImage:[UIImage imageNamed:@"TellSelected"] forState: UIControlStateHighlighted];
    [tell addTarget:self action:@selector(tellLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tell];

    UIButton *text = [[UIButton alloc] initWithFrame:CGRectMake(220.5, 173, 78, 100)];
    [text setBackgroundImage:[UIImage imageNamed:@"TextUnselected"] forState:UIControlStateNormal];
    [text setBackgroundImage:[UIImage imageNamed:@"TextSelected"] forState:UIControlStateHighlighted];
    [text addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];
    
    UIButton *directions = [[UIButton alloc] initWithFrame:CGRectMake(71.25, 295, 78, 100)];
    [directions setBackgroundImage:[UIImage imageNamed:@"DirectionsUnselected"] forState:UIControlStateNormal];
    [directions setBackgroundImage:[UIImage imageNamed:@"DirectionsSelected"] forState:UIControlStateHighlighted];
    [directions addTarget:self action:@selector(toAppleMaps) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:directions];
    
    UIButton *map = [[UIButton alloc] initWithFrame:CGRectMake(170.75, 295, 78, 100)];
    [map setBackgroundImage:[UIImage imageNamed:@"MapUnselected"] forState:UIControlStateNormal];
    [map setBackgroundImage:[UIImage imageNamed:@"MapSelected"] forState:UIControlStateHighlighted];
    [map addTarget:self action:@selector(viewMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:map];

    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(140, 450, 40, 40)];
    [close setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}

-(void)toAppleMaps
{
    NSString *address = [self.theirLastMessage.parts objectAtIndex:1];
    CLGeocoder *geo = [[CLGeocoder alloc] init];

    [geo geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocation *location = placemark.location;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f", location.coordinate.latitude, location.coordinate.longitude]]];
        }
        else{
            CLLocation *location = [self.locationManager fetchCurrentLocation];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f", location.coordinate.latitude, location.coordinate.longitude]]];
        }
    }];
        
        
//    LYRMessagePart *part = [self.theirLastMessage.parts objectAtIndex:1];
//    NSData *data = part.data;
//    CLLocation *theirLastLocation = [self.locationManager getLocationFromData:data];
//    CLLocation *myLocation = [self.locationManager fetchCurrentLocation];
//    if (theirLastLocation != myLocation) {
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f&t=k", theirLastLocation.coordinate.latitude, theirLastLocation.coordinate.longitude, myLocation.coordinate.latitude, myLocation.coordinate.latitude]]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f", theirLastLocation.coordinate.latitude, theirLastLocation.coordinate.longitude]]];
//    }
//    else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.apple.com/?q"]];
//    }
    
}

-(void)tellLocation
{
    NSMutableDictionary *convoContacts = [self.apiManager returnParticipantDictionary:self.conversation];
    [self.apiManager sendTellMessageToRecipients:convoContacts];
}

-(void)askLocation
{
    NSMutableDictionary *convoContacts = [self.apiManager returnParticipantDictionary:self.conversation];
    [self.apiManager sendAskMessageToRecipients:convoContacts];
}

-(void)sendText
{
    MessageCVC *message = [[MessageCVC alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] apiManager:(LayerAPIManager *)self.apiManager];
    message.locationManager = self.locationManager;
    message.parseController = self.parseController;
    message.conversation = self.conversation;
    [message fetchMessages];
    [self.navigationController pushViewController:message animated:YES];
}

-(void)viewMap
{
    MapVC *mapView = [[MapVC alloc] init];
    mapView.locationManager = self.locationManager;
    mapView.parseController = self.parseController;
    mapView.conversation = self.conversation;
    mapView.theirLastMessage = self.theirLastMessage;
    mapView.annotation = self.locationManager.annotation;
    mapView.apiManager = self.apiManager;
    [self.navigationController pushViewController:mapView animated:YES];
}

-(void)closeView
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
////    [self.navigationController dismissViewControllerAnimated:YES completion:^{
////        //
////    }];
//}


@end
