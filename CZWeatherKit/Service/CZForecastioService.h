//
//  CZForecastioService.h
//
//  Created by Sebastian Jachec on 04/06/2014.
//  Copyright (c) 2014 Sebastian Jachec. All rights reserved.
//


#pragma mark - Imports

@import Foundation;
#import "CZWeatherService.h"
#if TARGET_OS_IPHONE
@import UIKit;
#endif


#pragma mark - CZForecastioService Interface

/**
 CZForecastioService is the service object for interfacing with the Forecast.io
 developer API. CZForecastioService adopts the CZWeatherService protocol.
 
 CZForecastioService should not be subclassed.
 */
@interface CZForecastioService : NSObject <CZWeatherService>

@end