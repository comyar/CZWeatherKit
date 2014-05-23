//
//  NSString+Substring.m
//  Sol
//
//  Created by Comyar Zaheri on 8/10/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "NSString+CZWeatherKit_Substring.h"


#pragma mark - NSString Substring Implementation

@implementation NSString (CZWeatherKit_Substring)

#pragma mark Instance Methods

- (BOOL)contains:(NSString *)substring
{
    if([self rangeOfString:substring].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
