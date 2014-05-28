//
// CZWeatherLocationTestCase.m, Created by Eli Perkins
// Copyright (c) 2014, Comyar Zaheri, http://comyar.io
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
@import XCTest;
#import "CZWeatherLocation.h"


#pragma mark - CZWeatherLocationTestCase Interface

@interface CZWeatherLocationTestCase : XCTestCase

@end


#pragma mark - CZWeatherLocationTestCase Implementation

@implementation CZWeatherLocationTestCase

- (void)test_locationWithCityCountry
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithCity:@"London" country:@"England"];
    XCTAssertEqualObjects(location.locationData[CZWeatherLocationCityName], @"London", @"City name not equal");
    XCTAssertEqualObjects(location.locationData[CZWeatherLocationCountryName], @"England", @"Country name not equal");
    XCTAssertEqual(location.locationType, CZWeatherLocationCityCountryType, @"Location type is not correct");
}

- (void)test_locationWithCityState
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithCity:@"Austin" state:@"TX"];
    XCTAssertEqualObjects(location.locationData[CZWeatherLocationCityName], @"Austin", @"City name not equal");
    XCTAssertEqualObjects(location.locationData[CZWeatherLocationStateName], @"TX", @"State name not equal");
    XCTAssertEqual(location.locationType, CZWeatherLocationCityStateType, @"Location type is not correct");
}

- (void)test_locationWithZipcode
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithZipcode:@"02110"];
    XCTAssertEqual(location.locationData[CZWeatherLocationZipcodeName], @"02110", @"Zipcode not equal");
    XCTAssertEqual(location.locationType, CZWeatherLocationZipcodeType, @"Location type is not correct");
}

- (void)test_locationWithAutoIP
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithAutoIP];
    XCTAssertEqual(location.locationType, CZWeatherLocationAutoIPType, @"Location type is not correct");
}

- (void)test_locationWithCLLocationCoordinate2D
{
    const double accuracy               = 0.001;
    const CLLocationDegrees latitude    = -45.6;
    const CLLocationDegrees longitude   = 13.2;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CZWeatherLocation *location = [CZWeatherLocation locationWithCLLocationCoordinate2D:coordinate];
    
    CGPoint coordinatePoint = [location.locationData[CZWeatherLocationCoordinateName] CGPointValue];
    XCTAssertEqualWithAccuracy(coordinatePoint.x, latitude, accuracy, @"Location latitude not equal");
    XCTAssertEqualWithAccuracy(coordinatePoint.y, longitude, accuracy, @"Location longitude not equal");
    XCTAssertEqual(location.locationType, CZWeatherLocationCoordinateType, @"Location type is not correct");
}

- (void)test_locationWithCLLocation
{
    const double accuracy   = 0.001;
    const CLLocationDegrees latitude  = -45.6;
    const CLLocationDegrees longitude = 13.2;
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CZWeatherLocation *weatherLocation = [CZWeatherLocation locationWithCLLocation:location];
    
    CGPoint coordinatePoint = [weatherLocation.locationData[CZWeatherLocationCoordinateName] CGPointValue];
    XCTAssertEqualWithAccuracy(coordinatePoint.x, latitude, accuracy, @"Location latitude not equal");
    XCTAssertEqualWithAccuracy(coordinatePoint.y, longitude, accuracy, @"Location longitude not equal");
    XCTAssertEqual(weatherLocation.locationType, CZWeatherLocationCoordinateType, @"Location type is not correct");
}

@end
