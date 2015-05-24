//
//  CZWeatherForecastCondition.h
//  CZWeatherKit
//
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//


#pragma mark - Imports

@import Foundation;

#import "CZClimacons.h"
#import "CZWeatherKitTypes.h"


#pragma mark - CZWeatherForecastCondition Interface

/**
 A CZWeatherForecastCondition object represents the forecasted weather 
 conditions for a day.
 */
@interface CZWeatherForecastCondition : NSObject

- (instancetype)init NS_UNAVAILABLE;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The date of the forecast.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSDate *date;

/**
 A short description of the weather conditions, e.g. "Partly Cloudy".
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSString *summary;

/**
 The Climacon character that represents the weather conditions.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) Climacon climacon;

/**
 The humidity.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) CZHumidity humidity;

/**
 The low temperature.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) CZTemperature lowTemperature;

/**
 The high temperature.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) CZTemperature highTemperature;

@end
