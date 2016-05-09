//
//  UTA_API_STOPS.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/17/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTA_API_STOPS : NSObject
{
    NSData *stopMonitoringData;
    BOOL gotData;
    NSInteger depth;
    NSString *currentElement;
}

@property (nonatomic, retain) NSMutableArray *lineRef_arr;
@property (nonatomic, retain) NSMutableArray *estimatedDepartureTime;
@property (nonatomic, retain) NSMutableArray *directionRef;
@property (nonatomic, retain) NSMutableArray *direction;
@property (nonatomic, retain) NSMutableArray *publishedLineName;

- (NSData *)getStopMonitorForStopId: (NSString *)stopId;
- (void)parseStopMonitorData:(NSData *)data;

@end
