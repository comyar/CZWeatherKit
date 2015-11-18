//
//  CZForecastioTests.m
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

@import XCTest;

#import "CZWeatherKit.h"
#import "CZWeatherKitInternal.h"


#pragma mark - Constants

static const float epsilon = 0.001;


#pragma mark - CZForecastioAPITests Interface

@interface CZForecastioTests : XCTestCase

@end


#pragma mark - CZForecastioAPITests Implementation

@implementation CZForecastioTests

- (void)testForecastioRequest
{
    CZForecastioRequest *request = [CZForecastioRequest newForecastRequest];
    XCTAssertNil(request.date);
    
    NSDate *date = [NSDate date];
    request = [CZForecastioRequest newForecastRequestWithDate:date];
    XCTAssertEqualWithAccuracy([date timeIntervalSince1970], [request.date timeIntervalSince1970], epsilon);
}

- (void)testForecastioRequestCopying
{
    CZForecastioRequest *request = [[CZForecastioRequest alloc]_init];
    request.location = [CZWeatherLocation locationFromCity:@"Seattle" state:@"WA"];
    request.date = [NSDate date];
    request.key = @"apiKey";
    request.language = @"en";
    
    CZForecastioRequest *copy = [request copy];
    XCTAssertEqualObjects(request.key, copy.key);
    XCTAssertEqualObjects(request.location, copy.location);
    XCTAssertEqualObjects(request.language, copy.language);
    XCTAssertEqualObjects(request.date, copy.date);
}

- (void)testTransformRequest
{
    CZForecastioRequest *request = [CZForecastioRequest newForecastRequest];
    request.location = [CZWeatherLocation locationFromLatitude:47.6097
                                                     longitude:-122.3331];
    request.key = @"apiKey";
    NSURLRequest *URLRequest = [CZForecastioAPI transformRequest:request];
    XCTAssertEqualObjects(@"https://api.forecast.io/forecast/apiKey/47.6097,-122.3331?lang=en",
                          URLRequest.URL.absoluteString);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1432432281];
    request = [CZForecastioRequest newForecastRequestWithDate:date];
    request.location = [CZWeatherLocation locationFromLatitude:47.6097
                                                     longitude:-122.3331];
    request.key = @"apiKey";
    URLRequest = [CZForecastioAPI transformRequest:request];
    XCTAssertEqualObjects(@"https://api.forecast.io/forecast/apiKey/47.6097,-122.3331,1432432281?lang=en",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformResponseCurrent
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZForecastioAPI transformResponse:nil
                                                               data:data
                                                              error:nil
                                                         forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualWithAccuracy(47.6097, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.3331, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(ClimaconCloudMoon, weatherData.current.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", weatherData.current.summary);
    XCTAssertEqualWithAccuracy(61.95, weatherData.current.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(16.6389, weatherData.current.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432889194, [weatherData.current.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(338, weatherData.current.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(1.1, weatherData.current.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(1.770274, weatherData.current.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(1015.45, weatherData.current.pressure.mb, epsilon);
    XCTAssertEqualWithAccuracy(29.98634, weatherData.current.pressure.inch, epsilon);
    XCTAssertEqualWithAccuracy(79, weatherData.current.humidity, epsilon);
    
    XCTAssertEqual(49, [weatherData.hourlyForecasts count]);
    CZWeatherHourlyCondition *hour = weatherData.hourlyForecasts[0];
    XCTAssertEqual(ClimaconCloudMoon, hour.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", hour.summary);
    XCTAssertEqualWithAccuracy(62.61, hour.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(17.0055, hour.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432886400, [hour.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(355, hour.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(1.5, hour.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(2.414, hour.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(77, hour.humidity, epsilon);
    
    XCTAssertEqual(8, [weatherData.dailyForecasts count]);
    CZWeatherForecastCondition *day = weatherData.dailyForecasts[0];
    XCTAssertEqual(ClimaconCloudSun, day.climacon);
    XCTAssertEqualObjects(@"Partly cloudy throughout the day.", day.summary);
    XCTAssertEqualWithAccuracy(79.55, day.highTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(26.4166, day.highTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(59.8, day.lowTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(15.4444, day.lowTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432882800, [day.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(65, day.humidity, epsilon);
}

- (void)testTransformResponseTime
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_time"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZForecastioAPI transformResponse:nil
                                                               data:data
                                                              error:nil
                                                         forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualWithAccuracy(47.6097, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.3331, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(ClimaconRain, weatherData.current.climacon);
    XCTAssertEqualObjects(@"Light Rain", weatherData.current.summary);
    XCTAssertEqualWithAccuracy(47.99, weatherData.current.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(8.8833, weatherData.current.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(721925280, [weatherData.current.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(151, weatherData.current.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(7.61, weatherData.current.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(12.247, weatherData.current.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(1015.48, weatherData.current.pressure.mb, epsilon);
    XCTAssertEqualWithAccuracy(29.9872, weatherData.current.pressure.inch, epsilon);
    XCTAssertEqualWithAccuracy(97, weatherData.current.humidity, epsilon);
    
    XCTAssertEqual(24, [weatherData.hourlyForecasts count]);
    CZWeatherHourlyCondition *hour = weatherData.hourlyForecasts[0];
    XCTAssertEqual(ClimaconCloud, hour.climacon);
    XCTAssertEqualObjects(@"Overcast", hour.summary);
    XCTAssertEqualWithAccuracy(48.38, hour.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(9.1, hour.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(721900800, [hour.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(153, hour.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(6.21, hour.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(9.994, hour.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(95, hour.humidity, epsilon);
    
    XCTAssertEqual(1, [weatherData.dailyForecasts count]);
    CZWeatherForecastCondition *day = weatherData.dailyForecasts[0];
    XCTAssertEqual(ClimaconRain, day.climacon);
    XCTAssertEqualObjects(@"Rain until evening, starting again overnight.", day.summary);
    XCTAssertEqualWithAccuracy(50.32, day.highTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(10.1777, day.highTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(47.77, day.lowTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(8.7611, day.lowTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(721900800, [day.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(94, day.humidity, epsilon);
}

@end
