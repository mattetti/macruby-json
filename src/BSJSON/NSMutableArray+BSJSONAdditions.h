//
//  NSMutableArray+BSJSONAdditions.h
//  BSJSON
//
//  Created by Matt Aimonetti on 1/18/09.
//  Copyright 2009 m|a agile consulting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSScanner+BSJSONAdditions.h"

@interface NSMutableArray (BSJSONAdditions)
- (NSMutableString *)toJson;

@end
