//
//  CZWundergroundService.m
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

#import "CZWundergroundService.h"
#import "CZWeatherRequest.h"


#pragma mark - CZWundergroundService Implementation

@implementation CZWundergroundService

+ (instancetype)service
{
    return [CZWundergroundService new];
}

+ (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    return nil;
}

+ (CZWeatherData *)weatherDataForResponseData:(NSData *)data
{
    return nil;
}

@end
