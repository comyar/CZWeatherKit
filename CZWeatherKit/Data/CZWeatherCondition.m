//
//  CZWeatherState.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/20/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherCondition.h"


#pragma mark - CZWeatherCondition Class Extension

@interface CZWeatherCondition ()

// Date of the weather conditions represented.
@property (nonatomic) NSDate            *date;

// Word or phrase describing the conditions.
@property (nonatomic) NSString          *description;

// Climacon character that matches the condition description.
@property (nonatomic) Climacon          climaconCharacter;

// Predicted low temperature.
@property (nonatomic) CZTemperature     lowTemperature;

// Predicted high temperature.
@property (nonatomic) CZTemperature     highTemperature;

// Current temperature.
@property (nonatomic) CZTemperature     temperature;

// Relative humidity.
@property (nonatomic) CGFloat           humidity;

// Wind direction in degrees.
@property (nonatomic) CGFloat           windDegrees;

// Wind speed.
@property (nonatomic) CZWindSpeed       windSpeed;

@end


#pragma mark - CZWeatherCondition Implementation

@implementation CZWeatherCondition

- (instancetype)init
{
    if (self = [super init]) {
        self.lowTemperature     = (CZTemperature){CZWeatherKitNoValue, CZWeatherKitNoValue};
        self.highTemperature    = (CZTemperature){CZWeatherKitNoValue, CZWeatherKitNoValue};
        self.temperature        = (CZTemperature){CZWeatherKitNoValue, CZWeatherKitNoValue};
    }
    return self;
}

@end
