//
//  CZWundergroundRequest.h
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


#pragma mark - CZWundergroundRequest Interface

/**
 CZWundergroundRequest is a subclass of CZWeatherRequest used to make requests
 to the Wunderground API.
 
 http://www.wunderground.com/weather/api/d/docs
 */
@interface CZWundergroundRequest : CZWeatherRequest

// -----
// @name Creating a Wunderground Request
// -----

#pragma mark Creating a Wunderground Request

/**
 Creates and initializes a new request for the current weather conditions.
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/conditions
 
 @returns   Newly created request.
 */
+ (instancetype)newConditionsRequest;

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the next 3 days. 
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/forecast
 
 @returns   Newly created request.
 */
+ (instancetype)newForecastRequest;

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the next 10 days.
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/forecast10day
 
 @returns   Newly created request.
 */
+ (instancetype)newForecast10DayRequest;

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the next 36 hours.
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/hourly
 
 @returns   Newly created request.
 */
+ (instancetype)newHourlyRequest;

/**
 Creates and initializes a new request for the forecasted weather conditions for
 the next 10 days, by hour.
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/hourly10day
 
 @returns   Newly created request.
 */
+ (instancetype)newHourly10DayRequest;

/**
 Creates and initializes a new request for historical data.
 
 For more information, see
 http://www.wunderground.com/weather/api/d/docs?d=data/history
 
 @param     data
            The date in the past to get historical data for.
 @returns   Newly created request.
 */
+ (instancetype)newHistoryRequestForDate:(NSDate *)date;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The language of the requested data. 
 
 For more information regarding supported languages, see
 http://www.wunderground.com/weather/api/d/docs?d=language-support
 */
@property (NS_NONATOMIC_IOSONLY) NSString *language;

@end
