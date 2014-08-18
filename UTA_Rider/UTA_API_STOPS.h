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
}

- (NSData *)getStopMonitorForStopId: (NSString *)stopId;

@end
