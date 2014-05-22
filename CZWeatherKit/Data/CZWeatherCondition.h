//
//  CZWeatherState.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/20/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - Type Definitions

typedef struct {
    CGFloat f;
    CGFloat c;
} CZTemperature;


#pragma mark - Constants

// Forecast/Current Conditions
extern NSString * const CZConditionDateName;
extern NSString * const CZConditionDescriptionName;
extern NSString * const CZLowTemperatureName;
extern NSString * const CZHighTemperatureName;

// Current Conditions Only
extern NSString * const CZCurrentTemperatureName;
extern NSString * const CZCurrentRelativeHumidityName;
extern NSString * const CZCurrentWindDirectionName;
extern NSString * const CZCurrentWindSpeedName;
extern NSString * const CZCurrentAirPressureName;
extern NSString * const CZCurrentDewpointName;
extern NSString * const CZCurrentFeelsLikeTemperatureName;
extern NSString * const CZCurrentHeatIndexName;
extern NSString * const CZCurrentWindChillName;
extern NSString * const CZCurrentPrecipitationDayName;
extern NSString * const CZCurrentPrecipitationHourName;


#pragma mark - CZWeatherCondition Interface

@interface CZWeatherCondition : NSObject

// -----
// @name Using a Weather Condition
// -----

#pragma mark Using a Weather Condition

/**
 */
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end
