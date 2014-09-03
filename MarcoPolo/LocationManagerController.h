//
//  LocationManagerController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
#import "LayerAPIManager.h"
#import "MapViewAnnotation.h"

@class LocationManagerController;

@protocol LocationManagerControllerDelegate <NSObject>


@end


@interface LocationManagerController : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) CLLocation *current;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, weak) id<LocationManagerControllerDelegate>delegate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) LayerAPIManager *apiManager;
@property (nonatomic, strong) MapViewAnnotation *annotation;



-(void)launchLocationManager;
-(CLLocation *)fetchCurrentLocation;
-(void)returnLocationName:(CLLocation *)location completion:(void(^)(BOOL done, NSError *error))completion;
-(CLLocation *)getLocationFromData:(NSData *)data;
-(NSArray *)createAnnotationsFromMessages:(NSMutableArray *)array;
-(void)annotationFromMessage:(LYRMessage *)message;



-(MKMapView *)displayMap:(UIView *)view withAnnotation:(MapViewAnnotation *)annotation;




@end
