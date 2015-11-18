//
//  CZWundergroundTests.m
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


#pragma mark - CZWundergroundTests Interface

@interface CZWundergroundTests : XCTestCase

@end


#pragma mark - CZWundergroundTests Implementation

@implementation CZWundergroundTests

- (void)testWundergroundRequest
{
    XCTAssertEqualObjects(@"conditions", [CZWundergroundRequest newConditionsRequest].feature);
    XCTAssertEqualObjects(@"forecast", [CZWundergroundRequest newForecastRequest].feature);
    XCTAssertEqualObjects(@"forecast10day", [CZWundergroundRequest newForecast10DayRequest].feature);
    XCTAssertEqualObjects(@"hourly", [CZWundergroundRequest newHourlyRequest].feature);
    XCTAssertEqualObjects(@"hourly10day", [CZWundergroundRequest newHourly10DayRequest].feature);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1432422281];
    XCTAssertEqualObjects(@"history_20150523", [CZWundergroundRequest newHistoryRequestForDate:date].feature);
}

- (void)testWundergroundRequestCopying
{
    CZWundergroundRequest *request = [[CZWundergroundRequest alloc]_init];
    request.location = [CZWeatherLocation locationFromCity:@"Seattle" state:@"WA"];
    request.feature = @"feature";
    request.language = @"en";
    request.key = @"apiKey";
    
    CZWundergroundRequest *copy = [request copy];
    XCTAssertEqualObjects(request.key, copy.key);
    XCTAssertEqualObjects(request.feature, copy.feature);
    XCTAssertEqualObjects(request.language, copy.language);
    XCTAssertEqualObjects(request.location, copy.location);
}

- (void)testTransformConditionsRequest
{
    CZWundergroundRequest *request = [CZWundergroundRequest newConditionsRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.key = @"key";
    
    NSURLRequest *URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/conditions/lang:EN/q/CA/San_Francisco.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/conditions/lang:EN/q/FR/Paris.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/conditions/lang:EN/q/10.0000,-10.0000.json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformForecastRequest
{
    CZWundergroundRequest *request = [CZWundergroundRequest newForecastRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.key = @"key";
    
    NSURLRequest *URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast/lang:EN/q/CA/San_Francisco.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast/lang:EN/q/FR/Paris.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast/lang:EN/q/10.0000,-10.0000.json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformForecast10DayRequest
{
    CZWundergroundRequest *request = [CZWundergroundRequest newForecast10DayRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.key = @"key";
    
    NSURLRequest *URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast10day/lang:EN/q/CA/San_Francisco.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast10day/lang:EN/q/FR/Paris.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/forecast10day/lang:EN/q/10.0000,-10.0000.json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformHourlyRequest
{
    CZWundergroundRequest *request = [CZWundergroundRequest newHourlyRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.key = @"key";
    
    NSURLRequest *URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly/lang:EN/q/CA/San_Francisco.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly/lang:EN/q/FR/Paris.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly/lang:EN/q/10.0000,-10.0000.json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformHourly10DayRequest
{
    CZWundergroundRequest *request = [CZWundergroundRequest newHourly10DayRequest];
    request.location = [CZWeatherLocation locationFromCity:@"San Francisco" state:@"CA"];
    request.key = @"key";
    
    NSURLRequest *URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly10day/lang:EN/q/CA/San_Francisco.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromCity:@"Paris" country:@"FR"];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly10day/lang:EN/q/FR/Paris.json",
                          URLRequest.URL.absoluteString);
    
    request.location = [CZWeatherLocation locationFromLatitude:10.0 longitude:-10.0];
    URLRequest = [CZWundergroundAPI transformRequest:request];
    XCTAssertEqualObjects(@"http://api.wunderground.com/api/key/geolookup/hourly10day/lang:EN/q/10.0000,-10.0000.json",
                          URLRequest.URL.absoluteString);
}

- (void)testTransformResponseConditions
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_conditions"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(ClimaconCloud, weatherData.current.climacon);
    XCTAssertEqualObjects(@"Overcast", weatherData.current.summary);
    XCTAssertEqualWithAccuracy(63.5, weatherData.current.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(17.5, weatherData.current.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432416133, [weatherData.current.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(190, weatherData.current.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(1.0, weatherData.current.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(1.6, weatherData.current.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(1019, weatherData.current.pressure.mb, epsilon);
    XCTAssertEqualWithAccuracy(30.10, weatherData.current.pressure.inch, epsilon);
    XCTAssertEqualWithAccuracy(71, weatherData.current.humidity, epsilon);
}

- (void)testTransformResponseForecast
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_forecast"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(4, [weatherData.dailyForecasts count]);
    CZWeatherForecastCondition *condition = weatherData.dailyForecasts[0];
    XCTAssertEqual(ClimaconCloudSun, condition.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", condition.summary);
    XCTAssertEqualWithAccuracy(65.0, condition.highTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(18.0, condition.highTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(53.0, condition.lowTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(12.0, condition.lowTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432432800, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(65, condition.humidity, epsilon);
}

- (void)testTransformResponseForecast10
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_forecast10day"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(10, [weatherData.dailyForecasts count]);
    
    CZWeatherForecastCondition *condition = weatherData.dailyForecasts[0];
    XCTAssertEqual(ClimaconCloudSun, condition.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", condition.summary);
    XCTAssertEqualWithAccuracy(65.0, condition.highTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(18.0, condition.highTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(53.0, condition.lowTemperature.f, epsilon);
    XCTAssertEqualWithAccuracy(12.0, condition.lowTemperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432432800, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(65, condition.humidity, epsilon);

}

- (void)testTransformResponseHourly
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_hourly"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(36, [weatherData.hourlyForecasts count]);
    
    CZWeatherHourlyCondition *condition = weatherData.hourlyForecasts[0];
    XCTAssertEqual(ClimaconCloudSun, condition.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", condition.summary);
    XCTAssertEqualWithAccuracy(62.0, condition.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(17.0, condition.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432422000, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(269, condition.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(13.0, condition.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(21.0, condition.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(65, condition.humidity, epsilon);
}

- (void)testTransformResponseHourly10
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_hourly10day"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(240, [weatherData.hourlyForecasts count]);
    
    CZWeatherHourlyCondition *condition = weatherData.hourlyForecasts[0];
    XCTAssertEqual(ClimaconCloudSun, condition.climacon);
    XCTAssertEqualObjects(@"Partly Cloudy", condition.summary);
    XCTAssertEqualWithAccuracy(61.0, condition.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(16.0, condition.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432425600, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(270, condition.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(15.0, condition.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(24.0, condition.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(66, condition.humidity, epsilon);
}

- (void)testTransformResponseHistory
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"wunderground_history"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZWeatherData *weatherData = [CZWundergroundAPI transformResponse:nil
                                                                 data:data
                                                                error:nil
                                                           forRequest:nil];
#if TARGET_OS_IOS || TARGET_OS_OSX
    XCTAssertEqualObjects(@"US", weatherData.placemark.country);
    XCTAssertEqualObjects(@"US", weatherData.placemark.ISOcountryCode);
    XCTAssertEqualObjects(@"94101", weatherData.placemark.postalCode);
    XCTAssertEqualObjects(@"CA", weatherData.placemark.administrativeArea );
    XCTAssertEqualObjects(@"San Francisco", weatherData.placemark.locality);
    XCTAssertEqualWithAccuracy(37.77500916, weatherData.placemark.location.coordinate.latitude, epsilon);
    XCTAssertEqualWithAccuracy(-122.41825867, weatherData.placemark.location.coordinate.longitude, epsilon);
#endif
    XCTAssertEqual(28, [weatherData.hourlyForecasts count]);
    
    CZWeatherHourlyCondition *condition = weatherData.hourlyForecasts[0];
    XCTAssertEqual(ClimaconCloud, condition.climacon);
    XCTAssertEqualObjects(@"Overcast", condition.summary);
    XCTAssertEqualWithAccuracy(53.6, condition.temperature.f, epsilon);
    XCTAssertEqualWithAccuracy(12.0, condition.temperature.c, epsilon);
    XCTAssertEqualWithAccuracy(1432454160, [condition.date timeIntervalSince1970], 100);
    XCTAssertEqualWithAccuracy(260, condition.windDirection, epsilon);
    XCTAssertEqualWithAccuracy(8.1, condition.windSpeed.mph, epsilon);
    XCTAssertEqualWithAccuracy(13.0, condition.windSpeed.kph, epsilon);
    XCTAssertEqualWithAccuracy(82, condition.humidity, epsilon);
}

@end
