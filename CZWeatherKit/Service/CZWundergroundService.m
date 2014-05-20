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
@synthesize key = _key;

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    return nil;
}

- (CZWeatherData *)weatherDataForResponseData:(NSData *)data request:(CZWeatherRequest *)request
{
    return nil;
}

@end
