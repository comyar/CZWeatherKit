//
//  CZOpenWeatherMapTests.m
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


#pragma mark - CZOpenWeatherMapTests Interface

@interface CZOpenWeatherMapTests : XCTestCase

@end


#pragma mark - CZOpenWeatherMapTests Implementation

@implementation CZOpenWeatherMapTests

- (void)testOpenWeatherMapRequest
{
    XCTAssertEqualObjects(@"weather", [CZOpenWeatherMapRequest newCurrentRequest].feature);
    XCTAssertEqualObjects(@"forecast/hourly", [CZOpenWeatherMapRequest newHourlyForecastRequest].feature);
    XCTAssertEqualObjects(@"forecast/daily", [CZOpenWeatherMapRequest newDailyForecastRequestForDays:5].feature);
    XCTAssertEqualObjects(@"history/city", [CZOpenWeatherMapRequest newHistoryRequestFrom:nil to:nil].feature);
}

- (void)testOpenWeatherMapRequestCopying
{
    CZOpenWeatherMapRequest *request = [[CZOpenWeatherMapRequest alloc]_init];
    request.location = [CZWeatherLocation locationFromCity:@"Seattle" country:@"WA"];
    request.feature = @"feature";
    request.start = [NSDate date];
    request.end = [NSDate date];
    request.language = @"en";
    request.key = @"apiKey";
    request.days = 5;
    
    CZOpenWeatherMapRequest *copy = [request copy];
    XCTAssertEqualObjects(request.location, copy.location);
    XCTAssertEqualObjects(request.language, copy.language);
    XCTAssertEqualObjects(request.feature, copy.feature);
    XCTAssertEqualObjects(request.start, copy.start);
    XCTAssertEqualObjects(request.end, copy.end);
    XCTAssertEqualObjects(request.key, copy.key);
    XCTAssertEqual(request.days, copy.days);
}

- (void)testTransformCurrentRequest
{
    CZOpenWeatherMapRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.language = @"ru";
    request.key = @"APIKEY";
    NSURLRequest *URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/weather?q=San%20Francisco,US&lang=ru&mode=json&APPID=APIKEY",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    request.language = @"fr";
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/weather?q=Paris,FR&lang=fr&mode=json&APPID=APIKEY",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/weather?lat=10.0000&lon=-10.0000&lang=fr&mode=json&APPID=APIKEY",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformDailyForecastRequest
{
    CZOpenWeatherMapRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:5];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.language = @"ru";
    NSURLRequest *URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/daily?q=San%20Francisco,US&lang=ru&mode=json&cnt=5",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    request.language = @"fr";
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/daily?q=Paris,FR&lang=fr&mode=json&cnt=5",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=10.0000&lon=-10.0000&lang=fr&mode=json&cnt=5",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformHourlyForecastRequest
{
    CZOpenWeatherMapRequest *request = [CZOpenWeatherMapRequest newHourlyForecastRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.language = @"ru";
    NSURLRequest *URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/hourly?q=San%20Francisco,US&lang=ru&mode=json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    request.language = @"fr";
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/hourly?q=Paris,FR&lang=fr&mode=json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.openweathermap.org/data/2.5/forecast/hourly?lat=10.0000&lon=-10.0000&lang=fr&mode=json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformHistoryRequest
{
    NSDate *from = [NSDate dateWithTimeIntervalSince1970:1432432281];
    NSDate *to = [NSDate dateWithTimeIntervalSince1970:1432439281];
    
    CZOpenWeatherMapRequest *request = [CZOpenWeatherMapRequest newHistoryRequestFrom:from to:to];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.language = @"ru";
    NSURLRequest *URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://openweathermap.org/data/2.5/history/city?q=San%20Francisco,US&lang=ru&mode=json&type=hourly&start=1432432281&end=1432439281",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    request.language = @"fr";
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://openweathermap.org/data/2.5/history/city?q=Paris,FR&lang=fr&mode=json&type=hourly&start=1432432281&end=1432439281",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZOpenWeatherMapAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://openweathermap.org/data/2.5/history/city?lat=10.0000&lon=-10.0000&lang=fr&mode=json&type=hourly&start=1432432281&end=1432439281",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformResponseCurrent
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"openweathermap_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
    CZWeatherData *weatherData = [CZOpenWeatherMapAPI transformResponse:nil
                                                                   data:data
                                                                  error:nil
                                                             forRequest:request];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.42, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(ClimaconCloudMoon, weatherData.current.climacon);
    XCTAssertEqualObjects(@"Clear", weatherData.current.summary);
    XCTAssertEqualWithAccuracy(65.2765, weatherData.current.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(18.4869, weatherData.current.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1433035292, [weatherData.current.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(238.5050, weatherData.current.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(4.47387258, weatherData.current.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(7.2, weatherData.current.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(1016.9000, weatherData.current.pressure.mb, epsilon);
    XCTAssertEqualWithAccuracy(30.0291, weatherData.current.pressure.inch, epsilon);
    XCTAssertEqualWithAccuracy(68, weatherData.current.humidity, epsilon);
}

- (void)testTransformResponseDailyForecast
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"openweathermap_dailyforecast"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:5];
    CZWeatherData *weatherData = [CZOpenWeatherMapAPI transformResponse:nil
                                                                   data:data
                                                                  error:nil
                                                             forRequest:request];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.7749, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.4194, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(5, [weatherData.dailyForecasts count]);
    
    CZWeatherForecastCondition *condition = weatherData.dailyForecasts[0];
    
    XCTAssertEqual(ClimaconMoon, condition.climacon);
    XCTAssertEqualObjects(@"Clear", condition.summary);
    XCTAssertEqualWithAccuracy(50.2339, condition.lowTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(10.1299, condition.lowTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(81.1220, condition.highTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(27.2900, condition.highTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1433016000, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(44, condition.humidity, epsilon);
}

- (void)testTransformResponseHourlyForecast
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"openweathermap_hourlyforecast"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newHourlyForecastRequest];
    CZWeatherData *weatherData = [CZOpenWeatherMapAPI transformResponse:nil
                                                                   data:data
                                                                  error:nil
                                                             forRequest:request];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.7749, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.4194, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(40, [weatherData.hourlyForecasts count]);
    
    CZWeatherHourlyCondition *condition = weatherData.hourlyForecasts[0];
    
    XCTAssertEqual(ClimaconRainMoon, condition.climacon);
    XCTAssertEqualObjects(@"Rain", condition.summary);
    XCTAssertEqualWithAccuracy(65.2820, condition.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(18.4900, condition.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1433030400, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(238.5050, condition.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(4.47387258, condition.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(7.2, condition.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(68, condition.humidity, epsilon);
}

- (void)testTransformResponseHistory
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"openweathermap_history"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newHourlyForecastRequest];
    CZWeatherData *weatherData = [CZOpenWeatherMapAPI transformResponse:nil
                                                                   data:data
                                                                  error:nil
                                                             forRequest:request];
    
    XCTAssertEqual(17, [weatherData.hourlyForecasts count]);
    
    CZWeatherHourlyCondition *condition = weatherData.hourlyForecasts[0];
    
    XCTAssertEqual(ClimaconSun, condition.climacon);
    XCTAssertEqualObjects(@"Clear", condition.summary);
    XCTAssertEqualWithAccuracy(53.0239, condition.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(11.6799, condition.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1369728000, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(210.0, condition.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(6.934502499, condition.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(11.16, condition.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(58.0000, condition.humidity, epsilon);
}

@end
