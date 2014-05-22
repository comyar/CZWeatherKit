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

@property (nonatomic) CZWeatherCondition    *current;

@property (nonatomic) NSArray           *forecasts;

@property (nonatomic) NSDictionary      *location;

@property (nonatomic) NSDate            *timestamp;

@property (nonatomic) NSString          *serviceName;

@end


#pragma mark - CZWeatherData Implementation

@implementation CZWeatherData

@end
