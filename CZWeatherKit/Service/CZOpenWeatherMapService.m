//
//  CZOpenWeatherMapService.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/21/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherService_Internal.h"
#import "CZOpenWeatherMapService.h"
#import "CZWeatherRequest.h"


#pragma mark - CZOpenWeatherMapService Implementation

@implementation CZOpenWeatherMapService
@synthesize key = _key;
@synthesize serviceName = _serviceName;

- (instancetype)init
{
    if (self = [super init]) {
        _serviceName = @"Open Weather Map";
    }
    return self;
}

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    return nil;
}

- (CZWeatherData *)weatherDataForResponseData:(NSData *)data request:(CZWeatherRequest *)request
{
    return nil;
}

@end
