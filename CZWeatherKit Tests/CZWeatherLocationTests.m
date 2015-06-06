//
//  CZWeatherLocationTests.m
//  CZWeatherKit
//
//  Created by Comyar Zaheri on 6/5/15.
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

@import XCTest;

#import "CZWeatherKit.h"
#import "CZWeatherKitInternal.h"


#pragma mark - CZWeatherLocationTests Interface

@interface CZWeatherLocationTests : XCTestCase

@end


#pragma mark - CZWeatherLocationTests Implementation

@implementation CZWeatherLocationTests

- (void)testEquals
{
    CZWeatherLocation *a = [CZWeatherLocation locationFromCity:@"Seattle" country:@"US"];
    CZWeatherLocation *b = [CZWeatherLocation locationFromCity:@"Seattle" country:@"US"];
    XCTAssertEqualObjects(a, b);
    XCTAssertEqual([a hash], [b hash]);
    
    a = [CZWeatherLocation locationFromCity:@"Seattle" state:@"WA"];
    b = [CZWeatherLocation locationFromCity:@"Seattle" state:@"WA"];
    XCTAssertEqualObjects(a, b);
    XCTAssertEqual([a hash], [b hash]);
    
    a = [CZWeatherLocation locationFromCoordinate:CLLocationCoordinate2DMake(10.0, -10.0)];
    b = [CZWeatherLocation locationFromCoordinate:CLLocationCoordinate2DMake(10.0, -10.0)];
    XCTAssertEqualObjects(a, b);
    XCTAssertEqual([a hash], [b hash]);
    
    a = [CZWeatherLocation locationFromCity:@"Seattle" state:@"WA"];
    b = [CZWeatherLocation locationFromCity:@"Austin" state:@"TX"];
    
    XCTAssertNotEqualObjects(a, b);
    XCTAssertNotEqual([a hash], [b hash]);
}

@end
