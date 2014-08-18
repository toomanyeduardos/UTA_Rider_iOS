//
//  Route.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 3/28/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject <NSCoding>
{
    BOOL isEnabled;
}

- (void) setIsEnabled:(BOOL) value;
- (BOOL) getIsEnabled;

@property (nonatomic, strong) NSNumber *routeId;
@property (nonatomic, copy) NSString *routeLongName;
@property (nonatomic, copy) NSString *routeShortName;
@property (nonatomic, strong) NSNumber *routeType;

@end
