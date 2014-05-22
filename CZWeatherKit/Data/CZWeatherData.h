//
//  CZWeatherData.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/19/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - Forward Declarations

@class CZWeatherCondition;


#pragma mark - CZWeatherData Interface

@interface CZWeatherData : NSObject

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 */
@property (nonatomic, readonly) NSDictionary        *location;

/**
 */
@property (nonatomic, readonly) NSDate              *timestamp;

/**
 */
@property (nonatomic, readonly) NSString            *serviceName;

/**
 */
@property (nonatomic, readonly) NSArray             *forecasts;

/**
 */
@property (nonatomic, readonly) CZWeatherCondition  *current;

@end
