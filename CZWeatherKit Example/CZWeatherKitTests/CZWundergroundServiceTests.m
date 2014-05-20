//
//  CZWundergroundServiceTests.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 5/19/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#import "CZWeatherServiceTestCase.h"


@interface CZWundergroundServiceTests : CZWeatherServiceTestCase

@end

@implementation CZWundergroundServiceTests

#pragma mark Setup and Teardown

- (void)setUp
{
    self.request = [CZWeatherRequest request];
    self.service = [CZWundergroundService new];
    self.request.service = self.service;
    
    NSString *path              = [[NSBundle bundleForClass:[self class]]pathForResource:@"API_KEY" ofType:@"txt"];
    NSString *content           = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *wundergroundKey   = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.service.key = wundergroundKey;
}

- (void)tearDown
{
    self.request = nil;
    self.service = nil;
}

#pragma mark urlForRequest: Tests

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
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationAutoIP
{
    self.request.location[CZWeatherKitLocationName.AutoIPName] = @"autoip";
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/autoip.json", self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationStateCity
{
    NSString * const stateCity = @"TX/Austin";
    self.request.location[CZWeatherKitLocationName.StateCityName] = stateCity;
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, stateCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationCountryCity
{
    NSString * const countryCity = @"England/London";
    self.request.location[CZWeatherKitLocationName.CountryCityName] = countryCity;
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", self.service.key, countryCity];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

@end
