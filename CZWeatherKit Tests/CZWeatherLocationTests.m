//
//  CZWeatherLocationTests.m
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

- (void)testArchiving
{
    CZWeatherLocation *a = [CZWeatherLocation locationFromCity:@"Seattle" country:@"US"];
    
    [NSKeyedArchiver archiveRootObject:a toFile:[NSTemporaryDirectory() stringByAppendingString:@"CZWeatherLocation.archive"]];
    CZWeatherLocation *b = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSTemporaryDirectory() stringByAppendingString:@"CZWeatherLocation.archive"]];
    
    XCTAssertEqualObjects(a, b);
    XCTAssertEqual([a hash], [b hash]);
}

@end
