//
//  MapViewAnnotation.m
//  LocationsApp
//
//  Created by Meera Parat on 8/5/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;
@synthesize subtitle = _subtitle;

-(id) initWithTitle:(NSString *)title subtitle:(NSString *)address andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    _title = title;
    _subtitle = address;
    _coordinate = coordinate;
    return self;
}

@end
