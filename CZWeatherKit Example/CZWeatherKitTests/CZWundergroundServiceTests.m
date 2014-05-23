//
//  CZWundergroundServiceTests.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/19/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherServiceTestCase.h"

#pragma mark - Constants

//
static NSString * const apiKeyFilename                      = @"API_KEY";

//
static NSString * const currentJSONFilename                 = @"current_wunderground";

//
static NSString * const forecastLightJSONFilename           = @"forecastLight_wunderground";

//
static NSString * const forecastFullJSONFilename            = @"forecastFull_wunderground";

//
static NSString * const currentForecastLightJSONFilename    = @"current_forecastLight_wunderground";

//
static NSString * const currentForecastFullJSONFilename     = @"current_forecastFull_wunderground";


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
    self.request            = [CZWeatherRequest request];
    self.service            = [CZWundergroundService new];
    self.request.service    = self.service;
    
    self.service.key                = [self loadFile:apiKeyFilename extension:@"txt"];
    self.currentData                = [[self loadFile:currentJSONFilename extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastLightData          = [[self loadFile:forecastLightJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastFullData           = [[self loadFile:forecastFullJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.currentForecastLightData   = [[self loadFile:currentForecastLightJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.currentForecastFullData    = [[self loadFile:currentForecastFullJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)loadFile:(NSString *)filename extension:(NSString *)extension
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)tearDown
{
    self.request = nil;
    self.service = nil;
}

#pragma mark urlForRequest: Tests

- (void)test_urlForRequest_forecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.forecastDetail = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast light detail");
}

- (void)test_urlForRequest_forecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.forecastDetail = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast10day/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast full detail");
}

- (void)test_urlForRequest_conditionsLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail  = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions light detail");
}

- (void)test_urlForRequest_conditionsFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail  = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions full detail");
}

- (void)test_urlForRequest_conditionsForecastNoDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestNoDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    XCTAssertNil([self.service urlForRequest:self.request], @"URL should be nil if both forecast and conditions set to 'no detail'");
}

- (void)test_urlForRequest_conditionsForecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestLightDetail;
    self.request.forecastDetail  = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/forecast/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_conditionsForecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/forecast10day/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationCoordinate
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationZipcode
{
    NSString * const zipcode = @"77581";
    self.request.location[CZWeatherKitLocationName.ZipcodeName] = zipcode;
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, zipcode];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with zipcode");
}

- (void)test_urlForRequest_locationAutoIP
{
    self.request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/autoip.json", self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with autoIP");
}

- (void)test_urlForRequest_locationStateCity
{
    NSString * const stateCity = @"TX/Austin";
    self.request.location[CZWeatherKitLocationName.StateCityName] = stateCity;
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, stateCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with state/city");
}

- (void)test_urlForRequest_locationCountryCity
{
    NSString * const countryCity = @"England/London";
    self.request.location[CZWeatherKitLocationName.CountryCityName] = countryCity;
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, countryCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with country/city");
}

- (void)test_urlForRequest_missingKey
{
    self.request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    self.request.service.key        = nil;
    
    XCTAssertNil([self.service urlForRequest:self.request], @"URL should be nil when service is missing key");
}

#pragma mark weatherDataForResponseData Tests

- (void)test_weatherDataForResponseData_current
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];;
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestNoDetail;
    
    CZWeatherData *parsedData = [self.service weatherDataForResponseData:self.currentData request:self.request];
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(parsedData.currentCondition.currentTemperature.f, 84.6, 0.01, @"Current fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(parsedData.currentCondition.currentTemperature.c, 29.2, 0.01, @"Current celsius temperature not equal");
    XCTAssertEqualObjects(parsedData.currentCondition.description, @"Mostly Cloudy", @"Current description not equal");
    XCTAssertEqualObjects(parsedData.currentCondition.date, [NSDate dateWithTimeIntervalSince1970:1400611999], @"Current date not equal");
    XCTAssertEqual(parsedData.currentCondition.climaconCharacter, ClimaconCloud, @"Climacon character not equal");
}

- (void)test_weatherDataForResponseData_forecastLight
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestNoDetail;
    self.request.forecastDetail  = CZWeatherRequestLightDetail;
    
    CZWeatherData *parsedData = [self.service weatherDataForResponseData:self.forecastLightData request:self.request];
    
    // 3 Day forecast plus current day
    XCTAssertEqual([parsedData.forecastedConditions count], 4, @"Forecast light count not equal");
    
    CZWeatherCondition *firstCondition = parsedData.forecastedConditions[0];
    XCTAssertEqualObjects(firstCondition.date, [NSDate dateWithTimeIntervalSince1970:1400630400], @"First condition date not equal");
    XCTAssertEqualObjects(firstCondition.description, @"Clear", @"First condition description not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.f, 88.0, 0.01, @"First condition high fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.c, 31.0, 0.01, @"First condition high celsius temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.f, 69.0, 0.01, @"First condition low fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.c, 21.0, 0.01, @"First condition low celsius temperature not equal");
    XCTAssertEqual(firstCondition.climaconCharacter, ClimaconSun, @"Climacon character not equal");
}

- (void)test_weatherDataForResponseData_currentForecastLight
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail  = CZWeatherRequestLightDetail;
    
    CZWeatherData *parsedData = [self.service weatherDataForResponseData:self.currentForecastLightData request:self.request];
    
    XCTAssertEqualObjects(parsedData.currentCondition.description, @"Clear", @"Current description not equal");
    XCTAssertEqualObjects(parsedData.currentCondition.date, [NSDate dateWithTimeIntervalSince1970:1400728310], @"Current date not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(parsedData.currentCondition.currentTemperature.f, 77.5, 0.01, @"Current fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(parsedData.currentCondition.currentTemperature.c, 25.3, 0.01, @"Current celsius temperature not equal");
    
    // 3 Day forecast plus current day
    XCTAssertEqual([parsedData.forecastedConditions count], 4, @"Forecast light count not equal");
    
    CZWeatherCondition *firstCondition = parsedData.forecastedConditions[0];
    XCTAssertEqualObjects(firstCondition.date, [NSDate dateWithTimeIntervalSince1970:1400716800], @"First condition date not equal");
    XCTAssertEqualObjects(firstCondition.description, @"Clear", @"First condition description not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.f, 90.0, 0.01, @"First condition high fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.c, 32.0, 0.01, @"First condition high celsius temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.f, 69.0, 0.01, @"First condition low fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.c, 21.0, 0.01, @"First condition low celsius temperature not equal");
    XCTAssertEqual(firstCondition.climaconCharacter, ClimaconSun, @"Climacon character not equal");
}

#pragma mark Wunderground Request Tests

- (void)test_wundergroundRequest_full
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.currentDetail  = CZWeatherRequestFullDetail;
    self.request.forecastDetail = CZWeatherRequestFullDetail;
    
    if ([self.service.key length] > 0) {
        [self.request startWithCompletion:^(CZWeatherData *weatherData, NSError *error) {
            XCTAssertNotNil(weatherData, @"Weather Data is nil");
            XCTAssertNotNil(weatherData.timestamp, @"Timestamp is nil");
            XCTAssertNotEqualObjects(weatherData.serviceName, self.service.serviceName, @"Service name is not equal");
            XCTAssertNotNil(weatherData.currentCondition, @"Current condition is nil");
            XCTAssertNotEqual([weatherData.forecastedConditions count], 0, @"Forecast conditions count is 0");
        }];
    }
}

- (void)test_wundergroundRequest_configurationError
{
    self.request.service = nil;
    self.request.currentDetail  = CZWeatherRequestFullDetail;
    self.request.forecastDetail = CZWeatherRequestFullDetail;
    
    if ([self.service.key length] > 0) {
        [self.request startWithCompletion:^(CZWeatherData *weatherData, NSError *error) {
            XCTAssertNil(weatherData, @"Weather data should be nil");
            XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                             code:CZWeatherRequestConfigurationError
                                                         userInfo:nil], @"Error should be configuration error");
        }];
    }
}

- (void)test_wundergroundRequest_URLError
{
    self.request.currentDetail  = CZWeatherRequestFullDetail;
    self.request.forecastDetail = CZWeatherRequestFullDetail;
    
    if ([self.service.key length] > 0) {
        [self.request startWithCompletion:^(CZWeatherData *weatherData, NSError *error) {
            XCTAssertNil(weatherData, @"Weather data should be nil");
            XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                             code:CZWeatherRequestServiceURLError
                                                         userInfo:nil], @"Error should be URL error");
        }];
    }
}

@end
