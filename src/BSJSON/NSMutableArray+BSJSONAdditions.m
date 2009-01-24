//
//  NSMutableArray+BSJSONAdditions.m
//  BSJSON
//
//  Created by Matt Aimonetti on 1/18/09.
//  Copyright 2009 m|a agile consulting. All rights reserved.
//

#import "NSMutableArray+BSJSONAdditions.h"

@implementation NSMutableArray (BSJSONAdditions)

- (NSMutableString *)toDryJson{
	
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonArrayStartString];
	
	NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
	
	if ([self count] > 0) {
		[jsonString appendString:[jsonDic jsonStringForValue:[self objectAtIndex:0] withIndentLevel:0]];
	}
	
	int i;
	for (i = 1; i < [self count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [jsonDic jsonStringForValue:[self objectAtIndex:i] withIndentLevel:0]];
	}
	
	[jsonString appendString:jsonArrayEndString];
	return [jsonString autorelease];
}


- (NSMutableString *)toJson{
	
	NSMutableString *jsonString = [[NSMutableString alloc] init];
	[jsonString appendString:jsonArrayStartString];
	
	NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
	
	if ([self count] > 0) {
		[jsonString appendString:[jsonDic jsonStringForValue:[self objectAtIndex:0] withIndentLevel:0]];
	}
	
	int i;
	for (i = 1; i < [self count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [jsonDic jsonStringForValue:[self objectAtIndex:i] withIndentLevel:0]];
	}
	
	[jsonString appendString:jsonArrayEndString];
	return [jsonString autorelease];
}

@end
