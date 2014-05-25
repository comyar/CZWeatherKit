//
// CZWundergroundServiceTests.m
// Copyright (c) 2014, Comyar Zaheri
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#pragma mark - Imports

#import "CZWeatherServiceTestCase.h"


#if !(TARGET_OS_IPHONE)
#define valueWithCGPoint valueWithPoint
#endif



#pragma mark - Constants

//
static NSString * const apiKeyFilename                      = @"API_KEY";

//
static NSString * const currentJSONFilename                 = @"current_wunderground";

//
static NSString * const forecastLightJSONFilename           = @"forecastLight_wunderground";

//
static NSString * const forecastFullJSONFilename            = @"forecastFull_wunderground";


#pragma mark - CZWundergroundServiceTests Class Extension

@interface CZWundergroundServiceTests : CZWeatherServiceTestCase

//
@property (nonatomic) NSData *currentData;

//
@property (nonatomic) NSData *forecastLightData;

//
@property (nonatomic) NSData *forecastFullData;

//
@property (nonatomic) NSData *currentForecastLightData;

//
@property (nonatomic) NSData *currentForecastFullData;

@end


#pragma mark - CZWundergroundServiceTests Implementation

@implementation CZWundergroundServiceTests

#pragma mark Setup and Teardown

- (void)setUp
{
    self.service                    = [CZWundergroundService serviceWithKey:[self loadFile:apiKeyFilename extension:@"txt"]];
    self.currentData                = [[self loadFile:currentJSONFilename extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastLightData          = [[self loadFile:forecastLightJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastFullData           = [[self loadFile:forecastFullJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)loadFile:(NSString *)filename extension:(NSString *)extension
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)tearDown
{
    self.service = nil;
}

#pragma mark urlForRequest: Tests

- (void)test_urlForRequest_forecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast light detail");
}

- (void)test_urlForRequest_forecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast10day/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast full detail");
}

- (void)test_urlForRequest_conditionsLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions light detail");
}

- (void)test_urlForRequest_conditionsFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions full detail");
}

- (void)test_urlForRequest_locationCoordinate
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationZipcode
{
    NSString * const zipcode = @"77581";
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.ZipcodeName] = zipcode;
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, zipcode];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with zipcode");
}

- (void)test_urlForRequest_locationAutoIP
{
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    request.detailLevel = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/autoip.json", self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with autoIP");
}

- (void)test_urlForRequest_locationStateCity
{
    NSString * const stateCity = @"TX/Austin";
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.StateCityName] = stateCity;
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, stateCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with state/city");
}

- (void)test_urlForRequest_locationCountryCity
{
    NSString * const countryCity = @"England/London";
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CountryCityName] = countryCity;
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, countryCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with country/city");
}

#pragma mark weatherDataForResponseData Tests

- (void)test_weatherDataForResponseData_current
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];;
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    CZWeatherCondition *currentCondition = [self.service weatherDataForResponseData:self.currentData request:request];
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(currentCondition.temperature.f, 84.6, 0.01, @"Current fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(currentCondition.temperature.c, 29.2, 0.01, @"Current celsius temperature not equal");
    XCTAssertEqualObjects(currentCondition.description, @"Mostly Cloudy", @"Current description not equal");
    XCTAssertEqualObjects(currentCondition.date, [NSDate dateWithTimeIntervalSince1970:1400611999], @"Current date not equal");
    XCTAssertEqual(currentCondition.climaconCharacter, ClimaconCloud, @"Climacon character not equal");
    XCTAssertEqualWithAccuracy(currentCondition.humidity, 52.0, 0.01, @"Humidity not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windDegrees, 121.0, 0.01, @"Wind degrees not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windSpeed.kph, 3.2, 0.01, @"Wind speed kph not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windSpeed.mph, 2.0, 0.01, @"Wind speed mph not equal");
}

- (void)test_weatherDataForResponseData_forecastLight
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSArray *data = [self.service weatherDataForResponseData:self.forecastLightData request:request];
    
    // 3 Day forecast plus current day
    XCTAssertEqual([data count], 4, @"Forecast light count not equal");
    
    CZWeatherCondition *firstCondition = [data firstObject];
    XCTAssertEqualObjects(firstCondition.date, [NSDate dateWithTimeIntervalSince1970:1400630400], @"First condition date not equal");
    XCTAssertEqualObjects(firstCondition.description, @"Clear", @"First condition description not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.f, 88.0, 0.01, @"First condition high fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.c, 31.0, 0.01, @"First condition high celsius temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.f, 69.0, 0.01, @"First condition low fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.c, 21.0, 0.01, @"First condition low celsius temperature not equal");
    XCTAssertEqual(firstCondition.climaconCharacter, ClimaconSun, @"Climacon character not equal");
    
    XCTAssertEqualWithAccuracy(firstCondition.humidity, 74.0, 0.01, @"Humidity not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windDegrees, 173.0, 0.01, @"Wind degrees not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.kph, 23.0, 0.01, @"Wind speed kph not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.mph, 14.0, 0.01, @"Wind speed mph not equal");
}

#pragma mark Wunderground Request Tests

- (void)test_wundergroundRequest_full
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    if ([self.service.key length] > 0) {
        [request performRequestWithHandler:^(id data, NSError *error) {
            XCTAssertTrue([data isKindOfClass:[CZWeatherCondition class]], @"Data is not CZWeatherCondition instance");
        }];
    }
}

- (void)test_wundergroundRequest_configurationError
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = nil;
    
    if ([self.service.key length] > 0) {
        [request performRequestWithHandler:^(id data, NSError *error) {
            XCTAssertNil(data, @"Data should be nil");
            XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                             code:CZWeatherRequestConfigurationError
                                                         userInfo:nil], @"Error should be configuration error");
        }];
    }
}

- (void)test_wundergroundRequest_URLError
{
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.detailLevel = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    if ([self.service.key length] > 0) {
        [request performRequestWithHandler:^(id data, NSError *error) {
            XCTAssertNil(data, @"Data should be nil");
            XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                             code:CZWeatherRequestServiceURLError
                                                         userInfo:nil], @"Error should be URL error");
        }];
    }
}

@end
