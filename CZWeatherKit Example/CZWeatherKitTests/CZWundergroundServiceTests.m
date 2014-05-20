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

- (void)setUp
{
    self.request = [CZWeatherRequest request];
    self.service = [CZWundergroundService new];
    self.request.service = self.service;
    
    NSString *path              = [[NSBundle mainBundle]pathForResource:@"API_KEY" ofType:@""];
    NSString *content           = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *wundergroundKey   = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.service.key = wundergroundKey;
}

- (void)tearDown
{
    self.request = nil;
    self.service = nil;
}

- (void)test_urlForRequest_locationCoordinate
{
    self.request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(30.25, -97.75)];
    self.request.conditionsDetail   = CZWeatherRequestFullDetail;
    self.request.forecastDetail     = CZWeatherRequestNoDetail;
    
    NSURL *url = [self.service urlForRequest:self.request];
    NSString *expected = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/30.25,-97.25.json", self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

@end
