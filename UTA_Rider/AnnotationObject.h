//
//  AnnotationObject.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/1/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationObject : NSObject <MKAnnotation>

// coordinate (mandatory)
// title
// subtitle

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSNumber *routeType;
@property (nonatomic, strong) NSNumber *stop_id;
@property (nonatomic, copy) NSString *stop_code;

- initWithPosition:(CLLocationCoordinate2D) coords;

@end
