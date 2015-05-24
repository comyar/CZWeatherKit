//
//  CZWeatherData.m
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

#import "CZWeatherData.h"
#import "CZWeatherKitInternal.h"
#import "CZWeatherCurrentCondition.h"


#pragma mark - CZWeatherData Class Extension

@interface CZWeatherData ()

@property (NS_NONATOMIC_IOSONLY) CLPlacemark                *placemark;
@property (NS_NONATOMIC_IOSONLY) NSArray                    *dailyForecasts;
@property (NS_NONATOMIC_IOSONLY) NSArray                    *hourlyForecasts;
@property (NS_NONATOMIC_IOSONLY) CZWeatherCurrentCondition  *current;

@end


#pragma mark - CZWeatherData Implementation

@implementation CZWeatherData

- (instancetype)_init
{
    if (self = [super init]) {
        // nothing to do
    }
    return self;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.placemark = [aDecoder decodeObjectOfClass:[CLPlacemark class]
                                                forKey:@"placemark"];
        self.current = [aDecoder decodeObjectOfClass:[CZWeatherCurrentCondition class]
                                              forKey:@"current"];
        self.dailyForecasts = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectOfClass:[NSData class]
                                                                                                forKey:@"dailyForecasts"]];
        self.hourlyForecasts = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectOfClass:[NSData class]
                                                                                                 forKey:@"hourlyForecasts"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.placemark forKey:@"placemark"];
    [aCoder encodeObject:self.current forKey:@"current"];
    [aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.dailyForecasts]
                  forKey:@"dailyForecasts"];
    [aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.hourlyForecasts]
                  forKey:@"hourlyForecasts"];
}

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZWeatherData *copy = [[CZWeatherData alloc]_init];
    copy.placemark = [self.placemark copy];
    copy.current = [self.current copy];
    copy.dailyForecasts = [self.dailyForecasts copy];
    copy.hourlyForecasts = [self.hourlyForecasts copy];
    return copy;
}

@end
