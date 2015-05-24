//
//  CZWeatherLocation.h
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

@import Foundation;
@import CoreLocation;


#pragma mark - CZWeatherLocation Interface

/**
 A CZWeatherLocation object represents the location data required by a 
 CZWeatherDataRequest. This object incorporates the city, state, country, or
 geographical coordinates for a location whose weather data you wish to request.
 
 This class is designed to be used as is and should not be subclassed.
 */
@interface CZWeatherLocation : NSObject <NSCopying, NSSecureCoding, NSCoding>

- (instancetype)init NS_UNAVAILABLE;

// -----
// @name Creating a Weather Location
// -----

#pragma mark Creating a Weather Location

/**
 Creates and returns a weather location initialized with the given CLLocation.
 
 @param     location
            A CLLocation.
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromLocation:(CLLocation *)location;

/**
 Creates and returns a weather location initialized with the given CLPlacemark.
 
 @param     placemark
            A CLPlacemark.
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromPlacemark:(CLPlacemark *)placemark;

/**
 Creates and returns a weather location initialized with the given coordinate.
 
 @param     coordinate
            A CLLocationCoordinate2D
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 Creates and returns a weather location initialized with the given latitude
 and longitude.
 
 @param     latitude
            The latitude to use.
 @param     longitude
            The longitude to use.
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromLatitude:(CLLocationDegrees)latitude
                                  longitude:(CLLocationDegrees)longitude;

/**
 Creates and returns a weather location initialized with the given U.S. city
 and state. 
 
 This method should only be used for creating a CZWeatherLocation that 
 represents a city in the United States. For other countries, use the
 locationFromCity:country: selector instead.
 
 @param     city
            The city to use.
 @param     state
            The state to use.
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromCity:(NSString *)city
                                  state:(NSString *)state;

/**
 Creates and returns a weather location initialized with the given city
 and country.
 
 @param     city
            The city to use.
 @param     country
            The country to use.
 @return    A newly created CZWeatherLocation.
 */
+ (CZWeatherLocation *)locationFromCity:(NSString *)city
                                country:(NSString *)country;

@end
