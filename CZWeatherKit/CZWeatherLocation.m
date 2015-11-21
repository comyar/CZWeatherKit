//
//  CZWeatherLocation.m
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

#import "CZWeatherLocation.h"


#pragma mark - CZWeatherLocation Class Extension

@interface CZWeatherLocation ()

@property (NS_NONATOMIC_IOSONLY) NSString *city;
@property (NS_NONATOMIC_IOSONLY) NSString *state;
@property (NS_NONATOMIC_IOSONLY) NSString *country;
@property (assign, NS_NONATOMIC_IOSONLY) CLLocationCoordinate2D coordinate;

@end


#pragma mark - CZWeatherLocation Implementation

@implementation CZWeatherLocation

#pragma mark Creating a Weather Location

- (instancetype)_init
{
    if (self = [super init]) {
        // nothing to do
    }
    return self;
}

+ (CZWeatherLocation *)locationFromLocation:(CLLocation *)location
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.coordinate = location.coordinate;
    return new;
}

+ (CZWeatherLocation *)locationFromPlacemark:(CLPlacemark *)placemark
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.coordinate = placemark.location.coordinate;
    new.city = placemark.locality;
    new.country = placemark.country;
    return new;
}

+ (CZWeatherLocation *)locationFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.coordinate = coordinate;
    return new;
}

+ (CZWeatherLocation *)locationFromLatitude:(CLLocationDegrees)latitude
                                  longitude:(CLLocationDegrees)longitude
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return new;
}

+ (CZWeatherLocation *)locationFromCity:(NSString *)city
                                  state:(NSString *)state
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.city = [city copy];
    new.state = [state copy];
    return new;

}

+ (CZWeatherLocation *)locationFromCity:(NSString *)city
                                country:(NSString *)country
{
    CZWeatherLocation *new = [[CZWeatherLocation alloc]_init];
    new.city = [city copy];
    new.country = [country copy];
    return new;

}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[CZWeatherLocation class]]) {
        CZWeatherLocation *other = (CZWeatherLocation *)object;
        
        if (self.state && ![self.state isEqualToString:other.state]) {
            return NO;
        }
        
        if (self.country && ![self.country isEqualToString:other.country]) {
            return NO;
        }
        
        if (self.city && ![self.city isEqualToString:other.city]) {
            return NO;
        }
        
        if (self.coordinate.longitude != 0.0 && self.coordinate.latitude != 0.0) {
            return  (self.coordinate.latitude == other.coordinate.latitude &&
                     self.coordinate.longitude == other.coordinate.longitude);
        }
        
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    NSUInteger hash = [self.state hash] ^ [self.country hash] ^ [self.city hash];
    
    if (self.coordinate.latitude != 0.0){
        hash *= self.coordinate.latitude;
    }
    
    if (self.coordinate.longitude != 0.0) {
        hash *= self.coordinate.longitude;
    }
    
    return hash;
}

- (NSString *)description
{
    if (self.city && self.state) {
        return [NSString stringWithFormat:@"%@, %@",
                [self.city capitalizedString], [self.state capitalizedString]];
    } else if (self.city && self.country) {
        return [NSString stringWithFormat:@"%@, %@",
                [self.city capitalizedString], [self.country capitalizedString]];
    } else {
        return [NSString stringWithFormat:@"%.4f, %.4f",
                self.coordinate.latitude, self.coordinate.longitude];
    }
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.city = [aDecoder decodeObjectOfClass:[NSString class]
                                           forKey:@"city"];
        self.state = [aDecoder decodeObjectOfClass:[NSString class]
                                            forKey:@"state"];
        self.country = [aDecoder decodeObjectOfClass:[NSString class]
                                              forKey:@"country"];
        
        CLLocationDegrees latitude = (CLLocationDegrees)[aDecoder decodeDoubleForKey:@"coordinate.latitude"];
        CLLocationDegrees longitude = (CLLocationDegrees)[aDecoder decodeDoubleForKey:@"coordinate.longitude"];
        _coordinate = (CLLocationCoordinate2D) { latitude, longitude };
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.country forKey:@"country"];
    
    [aCoder encodeDouble:self.coordinate.latitude forKey:@"coordinate.latitude"];
    [aCoder encodeDouble:self.coordinate.longitude forKey:@"coordinate.longitude"];
}

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZWeatherLocation *copy = [[CZWeatherLocation alloc]_init];
    copy.city = [self.city copy];
    copy.state = [self.state copy];
    copy.country = [self.country copy];
    copy.coordinate = self.coordinate;
    return copy;
}

@end
