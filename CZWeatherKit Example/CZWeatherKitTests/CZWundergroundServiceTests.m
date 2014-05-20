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
static NSString * const conditionsJSONFilename      = @"conditions_wunderground";

//
static NSString * const forecastLightJSONFilename   = @"forecastLight_wunderground";

//
static NSString * const forecastFullJSONFilename    = @"forecastFull_wunderground";


#pragma mark - CZWundergroundServiceTests Class Extension

@interface CZWundergroundServiceTests : CZWeatherServiceTestCase

//
@property (nonatomic) NSData *conditionsData;

//
@property (nonatomic) NSData *forecastLightData;

//
@property (nonatomic) NSData *forecastFullData;

@end


#pragma mark - CZWundergroundServiceTests Implementation

@implementation CZWundergroundServiceTests

#pragma mark Setup and Teardown

- (void)setUp
{
    self.request            = [CZWeatherRequest request];
    self.service            = [CZWundergroundService new];
    self.service.key        = @"1234567890123456";
    self.request.service    = self.service;
    
    self.conditionsData     = [self loadFileData:conditionsJSONFilename];
    self.forecastLightData  = [self loadFileData:forecastLightJSONFilename];
    self.forecastFullData   = [self loadFileData:forecastFullJSONFilename];
}

- (NSData *)loadFileData:(NSString *)filename
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:@"json"];
    NSString *contents  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [contents dataUsingEncoding:NSUTF8StringEncoding];
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
    self.request.forecastDetail   = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast light detail");
}

- (void)test_urlForRequest_forecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.forecastDetail   = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast10day/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast full detail");
}

- (void)test_urlForRequest_conditionsLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions light detail");
}

- (void)test_urlForRequest_conditionsFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions full detail");
}

- (void)test_urlForRequest_conditionsForecastNoDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestNoDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    XCTAssertNil([self.service urlForRequest:self.request], @"URL should be nil if both forecast and conditions set to 'no detail'");
}

- (void)test_urlForRequest_conditionsForecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestLightDetail;
    self.request.forecastDetail     = CZWeatherRequestLightDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/forecast/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_conditionsForecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestFullDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/forecast10day/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationCoordinate
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%.4f,%.4f.json", self.service.key, latitude, longitude];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationZipcode
{
    NSString * const zipcode = @"77581";
    self.request.location[CZWeatherKitLocationName.ZipcodeName] = zipcode;
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, zipcode];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with zipcode");
}

- (void)test_urlForRequest_locationAutoIP
{
    self.request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/autoip.json", self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with autoIP");
}

- (void)test_urlForRequest_locationStateCity
{
    NSString * const stateCity = @"TX/Austin";
    self.request.location[CZWeatherKitLocationName.StateCityName] = stateCity;
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, stateCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with state/city");
}

- (void)test_urlForRequest_locationCountryCity
{
    NSString * const countryCity = @"England/London";
    self.request.location[CZWeatherKitLocationName.CountryCityName] = countryCity;
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, countryCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with country/city");
}

- (void)test_urlForRequest_missingKey
{
    self.request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    self.request.service.key        = nil;
    
    XCTAssertNil([self.service urlForRequest:self.request], @"URL should be nil when service is missing key");
}

@end
