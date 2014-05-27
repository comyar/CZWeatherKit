//
//  CZWeatherLocation.h
//  CZWeatherKit Example iOS
//
//  Created by Eli Perkins on 5/27/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CZWeatherLocation : NSObject

/**
 *  Location of the format @"{country}/{city}",
 *  e.g. @"England/London"
 */
@property (nonatomic, strong) NSString *countryCityName;

/**
 *  Location of the format @"{state}/{city}"
 *  e.g. @"TX/Austin"
 */
@property (nonatomic, strong) NSString *stateCityName;

/**
 *  Location zipcode as a string
 */
@property (nonatomic, strong) NSString *zipcode;

/**
 *  Location determined based on the IP address making the request
 */
@property (nonatomic, assign) BOOL autoIP;

/**
 *  Location coordinates, using latitude and longitude
 */
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

/**
 *  Initialize an object with a country city name
 *
 *  @param name Country city name as a string
 *
 *  @return Location object with countryCityName set
 */
+ (instancetype)locationWithCountryCityName:(NSString *)name;

/**
 *  Initialize an object with a state city name
 *
 *  @param name State city name as a string
 *
 *  @return Location object with stateCityName set
 */
+ (instancetype)locationWithStateCityName:(NSString *)name;

/**
 *  Initialize an object with a zipcode
 *
 *  @param zipcode Zipcode as a string
 *
 *  @return Location object with zipcode set
 */
+ (instancetype)locationWithZipcode:(NSString *)zipcode;

/**
 *  Initalize an object to use automatic IP address location
 *
 *  @return Location object with autoIP set to true
 */
+ (instancetype)locationWithAutoIP;

/**
 *  Initialize an object to use a specific latitude and longitude
 *
 *  Convenience method for +locationWithCoordinatePoint:
 *
 *  @param latitude  Latitude coordinate for the location
 *  @param longitude Longitutde coordinate for the location
 *
 *  @return Location with locationCoordinate set
 */
+ (instancetype)locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

/**
 *  Initialize an object to use a specific latitude and longitude point
 *
 *  @param point Point With
 *
 *  @return Location object with locationCoordinate set
 */
+ (instancetype)locationWithCoordinatePoint:(CLLocationCoordinate2D)point;

@end
