//
//  AnnotationObject.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/1/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "AnnotationObject.h"

@implementation AnnotationObject

@synthesize coordinate, title, subtitle, routeType, stop_id, stop_code;

- initWithPosition:(CLLocationCoordinate2D)coords
{
    if (self = [super init])
    {
        self.coordinate = coords;
    }
    
    return self;
}

@end
