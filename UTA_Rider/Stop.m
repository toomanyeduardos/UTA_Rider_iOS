//
//  Stop.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "Stop.h"

@implementation Stop

@synthesize stopCode, stopDescription, stopId, stopLatitude, stopLongitude, stopName;

// Need to serialize this object to put it in nsuserdefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:stopCode forKey:@"stopCode"];
    [aCoder encodeObject:stopDescription forKey:@"stopDescription"];
    [aCoder encodeObject:stopId forKey:@"stopId"];
    [aCoder encodeObject:stopLatitude forKey:@"stopLatitude"];
    [aCoder encodeObject:stopLongitude forKey:@"stopLongitude"];
    [aCoder encodeObject:stopName forKey:@"stopName"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    self.stopCode = [aDecoder decodeObjectForKey:@"stopCode"];
    self.stopDescription = [aDecoder decodeObjectForKey:@"stopDescription"];
    self.stopId = [aDecoder decodeObjectForKey:@"stopId"];
    self.stopLatitude = [aDecoder decodeObjectForKey:@"stopLatitude"];
    self.stopLongitude = [aDecoder decodeObjectForKey:@"stopLongitude"];
    self.stopName = [aDecoder decodeObjectForKey:@"stopName"];

    return self;
}
@end





















