//
//  CZWeatherState.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/20/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import Foundation;

#if TARGET_OS_IPHONE
@import UIKit;
#endif

#import "Climacon.h"


#pragma mark - Type Definitions

/**
 Temperature struct.
 */
typedef struct {
    /** Fahrenheit */
    CGFloat f;
    /** Celsius */
    CGFloat c;
} CZTemperature;

/**
 Wind struct.
 */
typedef struct {
    /** Kilometers per hour */
    CGFloat kph;
    /** Miles per hour */
    CGFloat mph;
} CZWindSpeed;

/**
 Special values
 */
typedef NS_ENUM(NSInteger, CZWeatherKitValue) {
    /** Indicates no value is available */
    CZWeatherKitNoValue = NSIntegerMin
};


#pragma mark - CZWeatherCondition Interface

/**
 CZWeatherCondition represents the weather conditions at a particular time. This may be the current time or some
 time at a future date. 
 
 For example, a CZWeatherCondition object may be used to represent the current weather conditions as well as
 forecasted weather condtions at a later date.
 */
@interface CZWeatherCondition : NSObject

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Date of the weather conditions represented.
 
 The exact time of day and timezone is dependent on the specifc weather service's API. 
 However, it's (probably, hopefully...) safe to assume the month, day, and year are correct.
 */
@property (nonatomic, readonly) NSDate          *date;

/**
 Word or phrase describing the conditions. 
 
 (e.g. 'Clear', 'Rain', etc.) The possible words/phrases are defined by each weather
 service's API.
 */
@property (nonatomic, readonly) NSString        *description;

/**
 Climacon character that matches the condition description.
 */
@property (nonatomic, readonly) Climacon        climaconCharacter;

/**
 Predicted low temperature.
 
 If no values are available, each member of the struct will be equal to CZWeatherKitNoValue.
 */
@property (nonatomic, readonly) CZTemperature   lowTemperature;

/**
 Predicted high temperature.
 
 If no values are available, each member of the struct will be equal to CZWeatherKitNoValue.
 */
@property (nonatomic, readonly) CZTemperature   highTemperature;

/**
 Current temperature.
 
 If no values are available, each member of the struct will be equal to CZWeatherKitNoValue.
 */
@property (nonatomic, readonly) CZTemperature   currentTemperature;

/**
 Relative humidity.
 */
@property (nonatomic, readonly) CGFloat         humidity;

/**
 Wind direction in degrees.
 */
@property (nonatomic, readonly) CGFloat         windDegrees;

/**
 Wind speed.
 */
@property (nonatomic, readonly) CZWindSpeed     windSpeed;

@end
