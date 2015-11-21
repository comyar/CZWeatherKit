//
//  CZWeatherForecastCondition.m
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

#import "CZWeatherForecastCondition.h"
#import "CZWeatherForecastCondition+Internal.h"


#pragma mark - CZWeatherForecastCondition Class Extension

@interface CZWeatherForecastCondition ()

@property (NS_NONATOMIC_IOSONLY) NSDate *date;
@property (NS_NONATOMIC_IOSONLY) NSString *summary;
@property (assign, NS_NONATOMIC_IOSONLY) Climacon climacon;
@property (assign, NS_NONATOMIC_IOSONLY) CZHumidity humidity;
@property (assign, NS_NONATOMIC_IOSONLY) CZTemperature lowTemperature;
@property (assign, NS_NONATOMIC_IOSONLY) CZTemperature highTemperature;

@end


#pragma mark - CZWeatherForecastCondition Implementation

@implementation CZWeatherForecastCondition

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
        self.date = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"date"];
        self.summary = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"summary"];
        self.climacon = [aDecoder decodeIntegerForKey:@"climacon"];
        self.humidity = [aDecoder decodeFloatForKey:@"humidity"];
        
        float lowTemperatureF = [aDecoder decodeFloatForKey:@"lowTemperature.f"];
        float lowTemperatureC = [aDecoder decodeFloatForKey:@"lowTemperature.c"];
        _lowTemperature = (CZTemperature) { lowTemperatureF, lowTemperatureC };
        
        float highTemperatureF = [aDecoder decodeFloatForKey:@"highTemperature.f"];
        float highTemperatureC = [aDecoder decodeFloatForKey:@"highTemperature.c"];
        _highTemperature = (CZTemperature) { highTemperatureF, highTemperatureC };
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeInteger:self.climacon forKey:@"climacon"];
    [aCoder encodeFloat:self.humidity forKey:@"humidity"];
    
    [aCoder encodeFloat:self.lowTemperature.f forKey:@"lowTemperature.f"];
    [aCoder encodeFloat:self.lowTemperature.c forKey:@"lowTemperature.c"];
    
    [aCoder encodeFloat:self.highTemperature.f forKey:@"highTemperature.f"];
    [aCoder encodeFloat:self.highTemperature.c forKey:@"highTemperature.c"];
}

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZWeatherForecastCondition *copy = [[CZWeatherForecastCondition alloc]_init];
    copy.date = [self.date copy];
    copy.summary = [self.summary copy];
    copy.climacon = self.climacon;
    copy.humidity = self.humidity;
    copy.lowTemperature = self.lowTemperature;
    copy.highTemperature = self.highTemperature;
    return copy;
}

@end
