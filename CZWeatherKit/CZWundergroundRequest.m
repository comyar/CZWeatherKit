//
//  CZWundergroundRequest.m
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

#import "CZWundergroundRequest.h"
#import "CZWeatherKitInternal.h"
#import "CZWundergroundAPI.h"


#pragma mark - CZWundergroundRequest Class Extension

@interface CZWundergroundRequest ()

@property (NS_NONATOMIC_IOSONLY) NSString *feature;

@end


static NSDateFormatter *dateFormatter;

#pragma mark - CZWundergroundRequest Implementation

@implementation CZWundergroundRequest

+ (instancetype)newConditionsRequest
{
    return [[CZWundergroundRequest alloc]initWithFeature:@"conditions"];
}

+ (instancetype)newForecastRequest
{
    return [[CZWundergroundRequest alloc]initWithFeature:@"forecast"];
}

+ (instancetype)newForecast10DayRequest
{
    return [[CZWundergroundRequest alloc]initWithFeature:@"forecast10day"];
}

+ (instancetype)newHourlyRequest
{
    return [[CZWundergroundRequest alloc]initWithFeature:@"hourly"];
}

+ (instancetype)newHourly10DayRequest
{
    return [[CZWundergroundRequest alloc]initWithFeature:@"hourly10day"];
}

+ (instancetype)newHistoryRequestForDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyyMMdd";
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    NSString *feature = [NSString stringWithFormat:@"history_%@",
                         [dateFormatter stringFromDate:date]];
    return [[CZWundergroundRequest alloc]initWithFeature:feature];
}

- (instancetype)initWithFeature:(NSString *)feature
{
    if (self = [super _init]) {
        self.feature = feature;
    }
    return self;
}

- (void)sendWithCompletion:(CZWeatherRequestCompletion)completion
{
    [self dispatchWithAPI:self.API
               completion:completion];
}

- (Class)API
{
    return [CZWundergroundAPI class];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZWundergroundRequest *copy = [[CZWundergroundRequest alloc]_init];
    copy.feature = [self.feature copy];
    copy.language = [self.language copy];
    copy.location = [self.location copy];
    copy.key = [self.key copy];
    return copy;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super _init]) {
        self.location = [aDecoder decodeObjectOfClass:[CZWeatherLocation class]
                                               forKey:@"location"];
        self.language = [aDecoder decodeObjectOfClass:[NSString class]
                                               forKey:@"language"];
        self.feature = [aDecoder decodeObjectOfClass:[NSString class]
                                              forKey:@"feature"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.feature forKey:@"feature"];
}

@end
