//
//  Tweet.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/15/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, copy) NSString *tweet_title;
@property (nonatomic, copy) NSString *tweet_date;
@property (nonatomic, copy) NSString *tweet_screenName;
@property (nonatomic, retain) NSURL *tweet_url;

@end
