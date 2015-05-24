//
//  CZWeatherData.h
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
@import CoreLocation;

@class CZWeatherCurrentCondition;


#pragma mark - CZWeatherData Interface

/**
 A CZWeatherData object contains data returned for a weather request.
 */
@interface CZWeatherData : NSObject <NSCopying, NSCoding, NSSecureCoding>

- (instancetype)init NS_UNAVAILABLE;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The placemark representing the location the data was retrieved for.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) CLPlacemark *placemark;

/**
 An array of CZWeatherForecastCondition objects.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSArray *dailyForecasts;

/**
 An array of CZWeatherHourlyCondition objects.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSArray *hourlyForecasts;

/**
 The current weather conditions.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) CZWeatherCurrentCondition *current;

@end
