//
//  CZOpenWeatherMapServiceTests.m
//  CZWeatherKit Tests
//
//  Created by Comyar Zaheri on 5/24/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZWeatherServiceTestCase.h"
#import "CZOpenWeatherMapService.h"


#pragma mark - Constants

//
static NSString * const currentJSONFilename                 = @"";

//
static NSString * const forecastLightJSONFilename           = @"";

//
static NSString * const forecastFullJSONFilename            = @"";


#pragma mark - CZOpenWeatherMapServiceTests Interface

@interface CZOpenWeatherMapServiceTests : CZWeatherServiceTestCase

//
@property (nonatomic) NSData *currentData;

//
@property (nonatomic) NSData *forecastLightData;

//
@property (nonatomic) NSData *forecastFullData;

@end


#pragma mark - CZOpenWeatherMapServiceTests Implementation

@implementation CZOpenWeatherMapServiceTests

- (void)setUp
{
    [super setUp];
    self.service            = [CZOpenWeatherMapService serviceWithKey:self.keys[@"openweathermap"]];
    self.currentData        = [[self loadFile:currentJSONFilename       extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastLightData  = [[self loadFile:forecastLightJSONFilename extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastFullData   = [[self loadFile:forecastFullJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)loadFile:(NSString *)filename extension:(NSString *)extension
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)test_urlForRequest_forecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    request.detailLevel = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/hourly?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast light detail");
}

@end
