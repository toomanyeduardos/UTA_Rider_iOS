//
//  AnnotationView.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/1/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "AnnotationView.h"
#import "AnnotationObject.h"

@implementation AnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    // annotation
    AnnotationObject *myAnnotation = (AnnotationObject *)annotation;
    
    switch ([myAnnotation.routeType integerValue])
    {
        case 0: // Trax
            self.image = [UIImage imageNamed:@"train_red.png"];
            break;
        case 1: // Nothing
            break;
        case 2: // FrontRunner
            self.image = [UIImage imageNamed:@"frontrunner_north.png"];
            break;
        case 3: // Bus
            self.image = [UIImage imageNamed:@"train_blue.png"];    // need to change this to a bus icon
            break;
        case 99:    // Station
            self.image = [UIImage imageNamed:@"train_station.png"];
            break;
    }
    
    self.enabled = YES;
    self.canShowCallout = YES;
    
    return self;
}

@end
