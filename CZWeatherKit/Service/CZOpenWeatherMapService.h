//
//  CZOpenWeatherMapService.h
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/21/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import Foundation;
#import "CZWeatherService.h"


#pragma mark - CZOpenWeatherMapService Interface

/**
 CZOpenWeatherMapService is the service object for interfacing with the Open Weather Map
 developer API. CZOpenWeatherMapService adopts the CZWeatherService protocol.
 
 CZOpenWeatherMapService should not be subclassed.
 */
@interface CZOpenWeatherMapService : NSObject <CZWeatherService>

@end
