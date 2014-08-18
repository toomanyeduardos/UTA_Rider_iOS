//
//  Utilities.h
//  UTA_Rider
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSArray *) parseCSVFileWithFileName:(NSString *)filename fileType:(NSString *)filetype;

@end
