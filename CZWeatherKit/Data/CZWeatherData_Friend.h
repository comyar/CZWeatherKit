//
//  CZWeatherData_Friend.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/20/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherData.h"


#pragma mark - Forward Declarations

@class CZWeatherState;


#pragma mark - CZWeatherData Friend Category

@interface CZWeatherData (Friend)

/**
 */
- (void)setTimestamp:(NSDate *)timestamp;

/**
 */
- (void)setCurrentConditions:(CZWeatherState *)currentConditions;

/**
 */
- (void)setForecasts:(NSArray *)forecasts;

/**
 */
- (void)setLocation:(NSDictionary *)location;

/**
 */
- (void)setServiceName:(NSString *)serviceName;

@end