//
//  Contact.m
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize username = _username;
@synthesize userID = _userID;
@synthesize exists = _exists;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.firstName = [decoder decodeObjectForKey:@"firstName"];
    self.lastName = [decoder decodeObjectForKey:@"lastName"];
    self.username = [decoder decodeObjectForKey:@"username"];
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.exists = [decoder decodeObjectForKey:@"exists"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeBool:self.exists forKey:@"exists"];
}


@end
