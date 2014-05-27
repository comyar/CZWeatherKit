//
//  CZWeatherLocationTestCase.m
//  CZWeatherKit Tests
//
//  Created by Eli Perkins on 5/27/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CZWeatherKit.h"

@interface CZWeatherLocationTestCase : XCTestCase

@end

@implementation CZWeatherLocationTestCase

- (void)testCountryCityName
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithCountryCityName:@"England/London"];
    XCTAssertEqual(location.countryCityName, @"England/London", @"Country city names not equal");
}

- (void)testStateCityName
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithStateCityName:@"TX/Austin"];
    XCTAssertEqual(location.stateCityName, @"TX/Austin", @"State city names not equal");
}

- (void)testZipcode
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithZipcode:@"02110"];
    XCTAssertEqual(location.zipcode, @"02110", @"Zipcodes not equal");
}

- (void)testAutoIP
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithAutoIP];
    XCTAssertTrue(location.autoIP, @"Auto IP not set to true");
}

- (void)testLocationCoordinate
{
    CZWeatherLocation *location = [CZWeatherLocation locationWithLatitude:-45.6 longitude:13.2];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-45.6, 13.2);
    
    double accuracy = 0.001;
    
    XCTAssertEqualWithAccuracy(location.locationCoordinate.latitude, coordinate.latitude, accuracy, @"Location latitudes not equal");
    XCTAssertEqualWithAccuracy(location.locationCoordinate.longitude, coordinate.longitude, accuracy, @"Location longitudes not equal");
    
    location = [CZWeatherLocation locationWithCoordinatePoint:CLLocationCoordinate2DMake(-45.6, 13.2)];
    
    XCTAssertEqualWithAccuracy(location.locationCoordinate.latitude, coordinate.latitude, accuracy, @"Location latitudes not equal");
    XCTAssertEqualWithAccuracy(location.locationCoordinate.longitude, coordinate.longitude, accuracy, @"Location longitudes not equal");
}

@end
