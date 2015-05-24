//
//  CZForecastioRequest.h
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

#import "CZWeatherRequest.h"


#pragma mark - CZForecastioRequest Interface

/**
 CZForecastioRequest is a subclass of CZWeatherRequest used to make requests
 to the Forecast.io API.
 
 https://developer.forecast.io/docs/v2
 */
@interface CZForecastioRequest : CZWeatherRequest

// -----
// @name Creating a Forecast.io Request
// -----

#pragma mark Creating a Forecast.io Request

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the next week.
 
 For more information, see
 https://developer.forecast.io/docs/v2#forecast_call
 
 @return    Newly created request.
 */
+ (instancetype)newForecastRequest;

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the given date.
 
 For more information, see
 https://developer.forecast.io/docs/v2#time_call
 
 @param     date
            The date to request the forecast for, may be in the past or future.
 @return    Newly created request.
 */
+ (instancetype)newForecastRequestWithDate:(NSDate *)date;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The language of the requested data.
 
 For more information regarding supported languages, see
 https://developer.forecast.io/docs/v2#options
 */
@property (NS_NONATOMIC_IOSONLY) NSString *language;

/**
 The date to retrieve the forecast for, may be nil.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSDate *date;

@end
