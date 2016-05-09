//
//  Route.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 3/28/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "Route.h"

@implementation Route
@synthesize routeId, routeLongName, routeShortName, routeType, isFavoriteRoute, isEnabled;

// Need to serialize this object to put it in nsuserdefaults
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:routeId forKey:@"routeId"];
    [aCoder encodeObject:routeLongName forKey:@"routeLongName"];
    [aCoder encodeObject:routeShortName forKey:@"routeShortName"];
    [aCoder encodeObject:routeType forKey:@"routeType"];
    [aCoder encodeBool:isFavoriteRoute forKey:@"isFavoriteRoute"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    self.routeId = [aDecoder decodeObjectForKey:@"routeId"];
    self.routeLongName = [aDecoder decodeObjectForKey:@"routeLongName"];
    self.routeShortName = [aDecoder decodeObjectForKey:@"routeShortName"];
    self.routeType = [aDecoder decodeObjectForKey:@"routeType"];
    self.isFavoriteRoute = [aDecoder decodeBoolForKey:@"isFavoriteRoute"];
    
    return self;
}

@end
