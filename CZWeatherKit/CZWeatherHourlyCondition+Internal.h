//
//  CZWeatherHourlyCondition+Internal.h
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

#import "CZWeatherHourlyCondition.h"


#pragma mark - CZWeatherHourlyCondition Internal Category Interface

/**
 @warning Not for external use.
 */
@interface CZWeatherHourlyCondition (Internal)

// -----
// @name Internal
// -----

#pragma mark Internal

/**
 @warning Not for external use.
 */
- (instancetype)_init;

/**
 @warning Not for external use.
 */
@property (NS_NONATOMIC_IOSONLY) NSDate *date;

/**
 @warning Not for external use.
 */
@property (copy, NS_NONATOMIC_IOSONLY) NSString *summary;

/**
 @warning Not for external use.
 */
@property (assign, NS_NONATOMIC_IOSONLY) Climacon climacon;

/**
 @warning Not for external use.
 */
@property (assign, NS_NONATOMIC_IOSONLY) CZHumidity humidity;

/**
 @warning Not for external use.
 */
@property (assign, NS_NONATOMIC_IOSONLY) CZWindSpeed windSpeed;

/**
 @warning Not for external use.
 */
@property (assign, NS_NONATOMIC_IOSONLY) CZWindDirection windDirection;

/**
 @warning Not for external use.
 */
@property (assign, NS_NONATOMIC_IOSONLY) CZTemperature temperature;

@end
