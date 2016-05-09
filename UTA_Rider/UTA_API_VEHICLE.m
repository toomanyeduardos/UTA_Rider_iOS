//
//  UTA_API.m
//  Test_UTA_API
//
//  Created by Eduardo Flores on 1/19/13.
//  Copyright (c) 2013 Eduardo Flores. All rights reserved.
//

/*
 *
 *  More info on this API:
 *  http://developer.rideuta.com/DeveloperResources/VehicleByRouteInstructions.aspx
 *
 */

#import "UTA_API_VEHICLE.h"
#import "XMLReader.h"
#import "UTA_Keys.h"

@implementation UTA_API_VEHICLE

@synthesize recordedAtTime_arr;
@synthesize lineRef_arr;
@synthesize dataFrameRef_arr;
@synthesize datedVehicleJourneyRef_arr;
@synthesize publishedLineName_arr;
@synthesize originRef_arr;
@synthesize destinationRef_arr;
@synthesize longitude_arr;
@synthesize latitude_arr;
@synthesize stopPointName_arr, stopPointRef_arr;

- (NSData *)getVehicleMonitorForRouteNumber:(NSString *)routeNumber
{
    // UTA's sample
    // For vehicles servicing a route.
    // http://api.rideuta.com/SIRI/SIRI.svc/VehicleMonitor/ByRoute?route={RouteID}&onwardcalls={OnwardCalls}&usertoken={UserToken}
    // RouteID – The route to query. (E.g. 2 for route 2, 35M for route 35M)
    // Sample: http://api.rideuta.com/SIRI/SIRI.svc/VehicleMonitor/ByRoute?route=2&onwardcalls=true&usertoken=XXXXXXXXXXX
    
    NSString *urlAsString = @"http://api.rideuta.com/SIRI/SIRI.svc/VehicleMonitor/ByRoute";
    
    urlAsString = [urlAsString stringByAppendingString:@"?route="];
    urlAsString = [urlAsString stringByAppendingString:routeNumber];     // Route number (example: "703" for red line
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
             vehicleMonitorData = data;
             
             //NSString* newStr = [[NSString alloc] initWithData:vehicleMonitorData encoding:NSUTF8StringEncoding];
             //NSLog(@"data = %@", newStr);
             
             //NSLog(@"vehicleMonitorData = %@", vehicleMonitorData);
             
//             NSDictionary *dict = [XMLReader dictionaryForXMLData:data
//                                                          options:XMLReaderOptionsProcessNamespaces
//                                                            error:&error];
//             NSLog(@"dict = %@", dict);
             
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
    
    return vehicleMonitorData;
}//end getVehicleMonitorForRouteNumber


- (void)parseVehicleMonitorData:(NSData *)data
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}//end parseVehicleMonotorData


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Document started", nil);
    depth = 0;
    currentElement = nil;
    
    recordedAtTime_arr = [[NSMutableArray alloc]init];
    lineRef_arr = [[NSMutableArray alloc]init];
    dataFrameRef_arr = [[NSMutableArray alloc]init];
    datedVehicleJourneyRef_arr = [[NSMutableArray alloc]init];
    publishedLineName_arr = [[NSMutableArray alloc]init];
    originRef_arr = [[NSMutableArray alloc]init];
    destinationRef_arr = [[NSMutableArray alloc]init];
    longitude_arr = [[NSMutableArray alloc]init];
    latitude_arr = [[NSMutableArray alloc]init];
    stopPointRef_arr = [[NSMutableArray alloc]init];
    stopPointName_arr = [[NSMutableArray alloc]init];

}//end parserDidStartDocument


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}//end parseErrorOccurred



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    
}//end parserDidStartElement


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{

}//end parserDidEndElement


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"currentElement = %@", currentElement);
//    NSLog(@"string = %@", string);
    
    if ([currentElement isEqualToString:@"RecordedAtTime"])
    {
        [recordedAtTime_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"LineRef"])
    {
        [lineRef_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"DataFrameRef"])
    {
        [dataFrameRef_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"DatedVehicleJourneyRef"])
    {
        [datedVehicleJourneyRef_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"PublishedLineName"])
    {
        [publishedLineName_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"OriginRef"])
    {
        [originRef_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"DestinationRef"])
    {
        [destinationRef_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"Longitude"])
    {
        [longitude_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"Latitude"])
    {
        [latitude_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"StopPointName"])
    {
        [stopPointName_arr addObject:string];
    }
    else if ([currentElement isEqualToString:@"StopPointRef"])
    {
        [stopPointRef_arr addObject:string];
    }
}//end parserFoundCharacters


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"Document finished", nil);
}//end parserDidEndDocument


- (void)showCurrentDepth
{
    //NSLog(@"Current depth: %d", depth);
}//end showCurrentDepth

@end













































