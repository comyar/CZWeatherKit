//
//  CZWeatherServiceTestCase.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/19/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import XCTest;
#import "CZWeatherKit.h"


#pragma mark - CZWeatherServiceTestCase Interface

/**
 */
@interface CZWeatherServiceTestCase : XCTestCase

/**
 */
@property (nonatomic) CZWeatherRequest      *request;

/**
 */
@property (nonatomic) id<CZWeatherService>  service;

@end
