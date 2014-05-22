//
//  CZWeatherData.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/19/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherData.h"


#pragma mark - CZWeatherData Class Extension

@interface CZWeatherData ()

// Date the data was retrieved.
@property (nonatomic) NSDate                *timestamp;

// Current conditions at the specified location.
@property (nonatomic) CZWeatherCondition    *currentCondition;

// Forecasted conditions at the specified location.
@property (nonatomic, copy) NSArray         *forecastedConditions;

// Location dictionary provided to the CZWeatherRequest object that retrieved the data.
@property (nonatomic, copy) NSDictionary    *location;

// Human-readable name for the service that retrieved the data.
@property (nonatomic, copy) NSString        *serviceName;

@end


#pragma mark - CZWeatherData Implementation

@implementation CZWeatherData

@end
