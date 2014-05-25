//
//  CZWeatherService_Internal.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/21/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "Climacon.h"
#import "CZWeatherCondition.h"


#pragma mark - CZWeatherCondition Friend Category

/**
 Friend category for CZWeatherCondition. Allows write access to a CZWeatherCondition object's properties.
 
 Should not be used outside of a weather service.
 */
@interface CZWeatherCondition (Friend)

- (void)setDate:(NSDate *)date;
- (void)setDescription:(NSString *)description;
- (void)setClimaconCharacter:(Climacon)climaconCharacter;
- (void)setTemperature:(CZTemperature)temperature;
- (void)setHighTemperature:(CZTemperature)highTemperature;
- (void)setLowTemperature:(CZTemperature)lowTemperature;
- (void)setWindDegrees:(CGFloat)windDegrees;
- (void)setWindSpeed:(CZWindSpeed)windSpeed;
- (void)setHumidity:(CGFloat)humidity;

@end