//
//  CZWeatherService_Internal.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/21/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherData.h"
#import "CZWeatherCondition.h"


#pragma mark - CZWeatherData Friend Category

/**
 Friend category for CZWeatherData. Allows write access to a CZWeatherData object's properties.
 
 Should not be used outside of a weather service.
 */
@interface CZWeatherData (Friend)

- (void)setTimestamp:(NSDate *)timestamp;
- (void)setCurrent:(CZWeatherCondition *)current;
- (void)setForecasts:(NSArray *)forecasts;
- (void)setLocation:(NSDictionary *)location;
- (void)setServiceName:(NSString *)serviceName;

@end


#pragma mark - CZWeatherCondition Friend Category

/**
 Friend category for CZWeatherCondition. Allows write access to a CZWeatherCondition object's properties.
 
 Should not be used outside of a weather service.
 */
@interface CZWeatherCondition (Friend)

- (void)setDate:(NSDate *)date;
- (void)setDescription:(NSString *)description;
- (void)setCurrentTemperature:(CZTemperature)currentTemperature;
- (void)setHighTemperature:(CZTemperature)highTemperature;
- (void)setLowTemperature:(CZTemperature)lowTemperature;

@end