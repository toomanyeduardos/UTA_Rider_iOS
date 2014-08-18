//
//  UTA_API_STOPS.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 6/17/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

/*
 SIRI StopMonitoring Request
 
 http://api.rideuta.com/SIRI/SIRI.svc/StopMonitor?stopid={StopID}&minutesout={MinutesOut}&onwardcalls={OnwardCalls}&filterroute={FilterRoute}&usertoken={UserToken}
 
 StopID – The Stop to query. This number can be found on any UTA stop sign (e.g. 133054)
 MinutesOut – The number of minutes away from the stop you want to query. Any vehicle that is this many minutes or less from the stop will be returned. (e.g 30 for 30 minutes or less away)
 OnwardCalls – Determines whether or not the response will include the stops (known as "calls" in SIRI) each vehicle is going to make. To get calls data, use value true, otherwise use value false.
 FilterRoute – Filters the vehicles by a a desired route. This is an optional value if the parameter is left blank all vehicles headed to the queried stop will be included. (e.g. 2 to filter for vehicles servicing route 2)
 Usertoken – your UTA developer API key. Go here to get one.
 
 For Example
 
 Request URI:
 http://api.rideuta.com/SIRI/SIRI.svc/StopMonitor?stopid=133054&minutesout=30&onwardcalls=true&filterroute=&usertoken=XXXXXXXXXXX
*/

#import "UTA_API_STOPS.h"
#import "UTA_Keys.h"

@implementation UTA_API_STOPS

- (NSData *)getStopMonitorForStopId: (NSString *)stopId
{
    
    NSString *urlAsString = @"http://api.rideuta.com/SIRI/SIRI.svc/StopMonitor";
    
    urlAsString = [urlAsString stringByAppendingString:@"?stopid="];
    urlAsString = [urlAsString stringByAppendingString:stopId];
    urlAsString = [urlAsString stringByAppendingString:@"&minutesout=30"];
    urlAsString = [urlAsString stringByAppendingString:@"&onwardcalls=true"];
    urlAsString = [urlAsString stringByAppendingString:@"&usertoken="];
    urlAsString = [urlAsString stringByAppendingString:UTA_TOKEN];         // My token

    NSURL *url = [NSURL URLWithString:urlAsString];
    
    gotData = NO;
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
         {
             stopMonitoringData = data;
             NSString *test = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"test = %@", test);
             //NSLog(@"data = %@", data);
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded");
         }
         else if (error != nil)
         {
             NSLog(@"Error happened = %@", error);
         }
         gotData = YES;
     }];
    while (!gotData)
    {
        sleep(1);
    }
    
    return stopMonitoringData;
}//end getStopMonitorForStopId

@end

















































