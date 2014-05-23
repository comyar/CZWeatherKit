//
//  NSString+Substring.h
//  Sol
//
//  Created by Comyar Zaheri on 8/10/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - NSString Substring Catagory

@interface NSString (CZWeatherKit_Substring)

// -----
// @name Instance Methods
// -----

#pragma mark Instance Methods

/**
 Returns YES if the NSString instance contains the given substring.
 @param substring   Substring to search for.
 @return            YES if contains the substring.
 */
- (BOOL)contains:(NSString *)substring;

@end
