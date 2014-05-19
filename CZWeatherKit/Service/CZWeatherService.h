//
//  CZWeatherService.h
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

@import Foundation;


#pragma mark - Forward Declarations

@class CZWeatherData;
@class CZWeatherRequest;


#pragma mark - Protocol

/**
 */
@protocol CZWeatherService <NSObject>

/**
 */
+ service;

/**
 */
+ (NSURL *)urlForRequest:(CZWeatherRequest *)request;

/**
 */
+ (CZWeatherData *)weatherDataForResponseData:(NSData *)data;

@end
