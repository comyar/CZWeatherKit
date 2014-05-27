//
//  CZWeatherLocation.m
//  CZWeatherKit Example iOS
//
//  Created by Eli Perkins on 5/27/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//

#import "CZWeatherLocation.h"

@interface CZWeatherLocation ()

@end

@implementation CZWeatherLocation

- (id)init {
    self = [super init];
    if (self) {
        // Initialize with an invalid object in case it is never set
        // See: http://stackoverflow.com/questions/8273107/how-to-check-that-cllocationcoordinate2d-is-not-empty
        _locationCoordinate = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

+ (instancetype)locationWithCountryCityName:(NSString *)name {
    CZWeatherLocation *location =  [[CZWeatherLocation alloc] init];
    location.countryCityName = name;
    return location;
}

+ (instancetype)locationWithStateCityName:(NSString *)name {
    CZWeatherLocation *location =  [[CZWeatherLocation alloc] init];
    location.stateCityName = name;
    return location;
}

+ (instancetype)locationWithZipcode:(NSString *)name {
    CZWeatherLocation *location =  [[CZWeatherLocation alloc] init];
    location.zipcode = name;
    return location;
}

+ (instancetype)locationWithAutoIP {
    CZWeatherLocation *location =  [[CZWeatherLocation alloc] init];
    location.autoIP = YES;
    return location;
}

+ (instancetype)locationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    return [[self class] locationWithCoordinatePoint:CLLocationCoordinate2DMake(latitude, longitude)];
}

+ (instancetype)locationWithCoordinatePoint:(CLLocationCoordinate2D)point {
    CZWeatherLocation *location =  [[CZWeatherLocation alloc] init];
    location.locationCoordinate = point;
    return location;
}

@end
