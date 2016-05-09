//
//  Stop.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stop : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *stopId;
@property (nonatomic, copy) NSString *stopCode;
@property (nonatomic, copy) NSString *stopName;
@property (nonatomic, copy) NSString *stopDescription;
@property (nonatomic, strong) NSNumber *stopLatitude;
@property (nonatomic, strong) NSNumber *stopLongitude;

@end
