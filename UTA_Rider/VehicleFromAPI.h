//
//  VehicleFromAPI.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/6/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleFromAPI : NSObject

@property (nonatomic, strong) NSNumber *routeId;
@property (nonatomic, copy) NSString *routeShortName;
@property (nonatomic, strong) NSNumber *routeType;
@property (nonatomic, strong) NSNumber *vehicleLatitude;
@property (nonatomic, strong) NSNumber *vehicleLongitude;


@end
