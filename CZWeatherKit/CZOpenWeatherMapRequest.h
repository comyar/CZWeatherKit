//
//  CZOpenWeatherMapRequest.h
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


#pragma mark - CZOpenWeatherMapRequest Interface

/**
 CZOpenWeatherMapRequest is a subclass of CZWeatherRequest used to make requests
 to the OpenWeatherMap API.
 
 http://openweathermap.org/api
 */
@interface CZOpenWeatherMapRequest : CZWeatherRequest

// -----
// @name Creating an Open Weather Map Request
// -----

#pragma mark Creating an Open Weather Map Request

/**
 Creates and initializes a new request for the current weather conditions.
 
 For more information, see
 http://openweathermap.org/current
 
 @returns   Newly created request.
 */
+ (instancetype)newCurrentRequest;

/**
 Creates and initializes a new request for daily forecasted weather conditions.
 
 For more information, see
 http://openweathermap.org/forecast
 
 @param     days
            The number of days of forecasted conditions to request.
 @returns   Newly created request.
 */
+ (instancetype)newDailyForecastRequestForDays:(NSInteger)days;

/**
 Creates and initializes a new request for hourly forecasted weather conditions.
 
 For more information, see
 http://openweathermap.org/forecast
 @returns   Newly created request.
 */
+ (instancetype)newHourlyForecastRequest;

/**
 Creates and initializes a new request for historical weather conditions.
 
 For more information, see
 http://openweathermap.org/history
 
 @param     from
            The start date to get historical conditions for.
 @param     to
            The end date to get historical conditions for.
 @returns   Newly created request.
 */
+ (instancetype)newHistoryRequestFrom:(NSDate *)from to:(NSDate *)to;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The language of the requested data.
 
 For more information regarding supported languages, see
 http://openweathermap.org/current#multi
 */
@property (NS_NONATOMIC_IOSONLY) NSString *language;

/**
 The start date to retrieve the historical conditions for, may be nil.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSDate *start;

/**
 The end date to retrieve the historical conditions for, may be nil.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSDate *end;

/**
 The number of days to retrieve forecasted weather conditions for; this value
 will be equal 
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSInteger days;

@end
