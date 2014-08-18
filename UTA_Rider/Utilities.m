//
//  Utilities.m
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSArray *) parseCSVFileWithFileName:(NSString *)filename fileType:(NSString *)filetype
{
    // Read content of filename.filetype into a string
    NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:filetype];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Then parse the string by csv
    NSArray *parsingRows = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *rowsArray = [[NSMutableArray alloc]init];
    for (NSString *singleLine in parsingRows)
    {
        if (![singleLine isEqualToString:@""])
        {
            NSArray *singleLineArray = [singleLine componentsSeparatedByString:@","];
            [rowsArray addObject:singleLineArray];
        }
    }
    
    NSArray *array = [NSArray arrayWithArray:rowsArray];
    return array;
}

@end
