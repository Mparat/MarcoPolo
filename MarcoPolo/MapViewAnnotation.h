//
//  MapViewAnnotation.h
//  LocationsApp
//
//  Created by Meera Parat on 8/5/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <LayerKit/LayerKit.h>



@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) LYRMessage *message;

-(id) initWithTitle:(NSString *)title subtitle:(NSString *)address andCoordinate:(CLLocationCoordinate2D)coordinate;

@end