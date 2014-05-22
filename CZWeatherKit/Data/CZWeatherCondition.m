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
@property (nonatomic) NSDate          *date;

// Word or phrase describing the conditions.
@property (nonatomic) NSString        *description;

// Predicted low temperature.
@property (nonatomic) CZTemperature   lowTemperature;

// Predicted high temperature.
@property (nonatomic) CZTemperature   highTemperature;

// Current temperature.
@property (nonatomic) CZTemperature   currentTemperature;

@end


#pragma mark - CZWeatherCondition Implementation

@implementation CZWeatherCondition

@end
