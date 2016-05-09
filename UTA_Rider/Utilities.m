//
//  Utilities.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "Utilities.h"
#import <Parse/Parse.h>
#import "Route.h"

@implementation Utilities

+ (NSArray *) parseCSVFileWithFileName:(NSString *)filename fileType:(NSString *)filetype
{
    // Read content of filename.filetype into a string
    NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:filetype];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Then parse the string by csv
    NSArray *parsingRows = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *rowsArray = [[NSMutableArray alloc]init];
//    for (NSString *singleLine in parsingRows)
    for (int i = 1; i < [parsingRows count]; i++)
    {
        NSString *singleLine = [parsingRows objectAtIndex:i];
        if (![singleLine isEqualToString:@""])
        {
            NSArray *singleLineArray = [singleLine componentsSeparatedByString:@","];
            [rowsArray addObject:singleLineArray];
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:rowsArray];
    return array;
}

+ (void)reportPageOpenToAnalytics:(NSString *)nameOfViewController
{
    NSDictionary *dimensions = @{@"ViewController": nameOfViewController};
    [PFAnalytics trackEventInBackground:@"PAGE" dimensions:dimensions
                                  block:^(BOOL succeeded, NSError * _Nullable error) {
                                      if (!error)
                                      {
                                          //NSLog(@"analytics from class %@ succeeded!", nameOfViewController);
                                      }
                                  }];
}

+(void)reportRoutesEnabledToAnalytics:(NSArray *)arrayOfRoutesEnabled
{
    NSMutableDictionary *dimensions = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < [arrayOfRoutesEnabled count]; i++)
    {
        NSString *key = [NSString stringWithFormat:@"RouteShortName_%d", i];
        Route *route = [arrayOfRoutesEnabled objectAtIndex:i];
        [dimensions setValue:[route routeShortName] forKey:key];
    }
    
    [PFAnalytics trackEventInBackground:@"ROUTES"
                             dimensions:dimensions
                                  block:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error)
        {
            //NSLog(@"routes reported!");
        }
    }];
}

@end















































