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

/**
 CZWeatherData encompasses all requested information by a CZWeatherRequest. It includes information regarding
 the location whose data was requested, the service providing the data, and a timestamp for when that data was
 retrieved. A CZWeatherData object will also contain data regarding the current conditions at the specified location,
 forecasted conditions at the specified location, or both.
 
 CZWeatherData objects are created by objects adopting the CZWeatherService protocol and their properties are intended to
 be immutable.
 */
@interface CZWeatherData : NSObject

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Date the data was retrieved.
 */
@property (nonatomic, readonly) NSDate                  *timestamp;

/**
 Current conditions at the specified location.
 */
@property (nonatomic, readonly) CZWeatherCondition      *currentCondition;

/**
 Forecasted conditions at the specified location.
 
 Array of CZWeatherCondition objects.
 */
@property (nonatomic, copy, readonly) NSArray           *forecastedConditions;

/**
 Location dictionary provided to the CZWeatherRequest object that
 retrieved the data.
 */
@property (nonatomic, copy, readonly) NSDictionary      *location;

/**
 Human-readable name for the service that retrieved the data.
 */
@property (nonatomic, copy, readonly) NSString          *serviceName;

@end
