//
//  LocationManagerController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LocationManagerController.h"
#import "MapViewAnnotation.h"


@implementation LocationManagerController

@synthesize locationManager;
@synthesize locations = _locations;
@synthesize current = _current;
@synthesize placemark = _placemark;

@synthesize map = _map;

-(void)launchLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:100.f];
    [self startCollectingLocations];
}

-(void)startCollectingLocations
{
    NSLog(@"Starting locations update");
    [locationManager startUpdatingLocation];
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        
        NSLog(@"Background updates are available for the app.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
    }
}

-(void)stopCollectingLocations
{
    NSLog(@"Stopped updating location");
    [locationManager stopUpdatingLocation];
}

#pragma mark - location manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Tells the delegate that new location data is available.
    //UIBackgroundMode required
    NSLog(@"Locations updated");
    self.locations = [[NSArray alloc] initWithArray:locations];
    
    // most recent location update is at the end of the locations array
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Updating locations failed with error: %@", error);
}


// Location methods

-(CLLocation *)fetchCurrentLocation
{
    return (CLLocation *)[self.locations objectAtIndex:([self.locations count]-1)];
}

-(void)returnLocationName:(CLLocation *)location completion:(void (^)(BOOL, NSError *))completion
{
    NSParameterAssert(completion);

    CLGeocoder *geo = [[CLGeocoder alloc] init];
    NSLog(@"%d", kCLErrorGeocodeFoundNoResult);
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
//            NSString *text = [NSString stringWithFormat:@"%@", [self.placemark.areasOfInterest objectAtIndex:0]];
            NSString *text = nil;
            if (!text) {
                text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@",
                        self.placemark.subThoroughfare, self.placemark.thoroughfare,
                        self.placemark.postalCode, self.placemark.locality,
                        self.placemark.administrativeArea];
            }
//            self.placemark.country
            self.name = text;
            completion(YES, nil);
        }
    }];
}


-(CLLocation *)getLocationFromData:(NSData *)data
{
    NSDictionary *coords = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    CLLocationDegrees lat = [[coords objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lon = [[coords objectForKey:@"lon"] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return location;
}

#pragma mark - MKMapView delegate methods

-(MKMapView *)displayMap:(UIView *)view withAnnotation:(MapViewAnnotation *)annotation
{
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [self.map setDelegate:self];

    self.map.showsUserLocation = YES;
    if (annotation) {
        [self.map addAnnotation:annotation];
        [self.map showAnnotations:self.map.annotations animated:YES];
    }

    MKCoordinateRegion mapRegion; // structure that defines which map region to display
    
    CLLocation *location;
    if (![self.map.annotations lastObject]) {
        location = [[CLLocation alloc]init];
        location = [self fetchCurrentLocation];
    }
    else{
        location = [[CLLocation alloc] initWithLatitude:((MapViewAnnotation *)[self.map.annotations lastObject]).coordinate.latitude longitude:((MapViewAnnotation *)[self.map.annotations lastObject]).coordinate.longitude];
    }
    
    mapRegion.center = location.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [self.map setRegion:mapRegion animated:YES];
    return self.map;
}

-(NSArray *)personFromMessage:(LYRMessage *)message forUserID:(NSString *)uid
{
    LYRMessagePart *recipientPart = [message.parts objectAtIndex:0];
    NSData *data = recipientPart.data;
    NSMutableDictionary *recipientInfo = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    return [recipientInfo objectForKey:uid];
}


-(NSMutableArray *)createAnnotationsFromMessages:(NSMutableArray *)array
{
    NSMutableArray *retVal = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        LYRMessage *message = (LYRMessage *)[array objectAtIndex:i];

        NSArray *person = [self personFromMessage:message forUserID:message.sentByUserID];
        NSString *title = [person objectAtIndex:1];
        
        LYRMessagePart *part2 = [((LYRMessage *)[array objectAtIndex:i]).parts objectAtIndex:1];
        NSData *data2 = part2.data;
        CLLocationCoordinate2D coord = ((CLLocation *)[self getLocationFromData:data2]).coordinate;
        
        [self returnLocationName:(CLLocation *)[self getLocationFromData:data2] completion:^(BOOL done, NSError *error) {
            if (!error) {
                MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title subtitle:self.name andCoordinate:coord];
                annotation.message = message;
                [retVal addObject:annotation];
            }
        }];
    }
    return retVal;
}

-(void)annotationFromMessage:(LYRMessage *)message
{
//    NSString *target = [[[message.parts objectAtIndex:1] componentsSeparatedByString:@"\n"] objectAtIndex:0];
    NSMutableArray *retVal = [NSMutableArray array];
    
    if (message) {
        LYRMessagePart *add = [message.parts objectAtIndex:1];
        NSString *address = [NSString stringWithUTF8String:[add.data bytes]];
        CLGeocoder *geo = [[CLGeocoder alloc] init];
        
        NSArray *person = [self personFromMessage:message forUserID:message.sentByUserID];
        NSString *title = [person objectAtIndex:1];
        
        [geo geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                CLLocation *location = placemark.location;
                MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title subtitle:address andCoordinate:location.coordinate];
                [retVal addObject:annotation];
                self.annotation = annotation;
//                [self displayMap:self.map withAnnotation:annotation];

            }
        }];
    }
//    return [retVal lastObject];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    return;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        pin.pinColor = MKPinAnnotationColorRed;
        pin.canShowCallout = YES;
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setTimeStyle:NSDateFormatterShortStyle];
        NSString *theTime = [timeFormat stringFromDate:((MapViewAnnotation *)annotation).message.sentAt];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setText:theTime];
        [pin.leftCalloutAccessoryView addSubview:timeLabel];
        
//        [mapView selectAnnotation:pin.annotation animated:YES]; // doesn't do anything...

    }
    else{
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        ((MKUserLocation *)annotation).title = @"My Location";
        [pin setSelected:YES animated:YES];
    }
    return pin;
}


@end
