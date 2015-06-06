//
//  CZOpenWeatherMapRequest.m
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

#import "CZOpenWeatherMapRequest.h"
#import "CZWeatherKitInternal.h"
#import "CZOpenWeatherMapAPI.h"


#pragma mark - CZOpenWeatherMapRequest Class Extension

@interface CZOpenWeatherMapRequest ()

@property (NS_NONATOMIC_IOSONLY) NSDate *end;
@property (NS_NONATOMIC_IOSONLY) NSDate *start;
@property (NS_NONATOMIC_IOSONLY) NSInteger days;
@property (NS_NONATOMIC_IOSONLY) NSString *feature;

@end


#pragma mark - CZOpenWeatherMapRequest Implementation

@implementation CZOpenWeatherMapRequest

#pragma mark Creating an Open Weather Map Request

+ (instancetype)newCurrentRequest
{
    return [[CZOpenWeatherMapRequest alloc]initWithFeature:@"weather"];
}

+ (instancetype)newDailyForecastRequestForDays:(NSInteger)days
{
    CZOpenWeatherMapRequest *request = [[CZOpenWeatherMapRequest alloc]initWithFeature:@"forecast/daily"];
    request.days = days;
    return request;
}

+ (instancetype)newHourlyForecastRequest
{
    CZOpenWeatherMapRequest *request = [[CZOpenWeatherMapRequest alloc]initWithFeature:@"forecast/hourly"];
    return request;
}

+ (instancetype)newHistoryRequestFrom:(NSDate *)from to:(NSDate *)to
{
    CZOpenWeatherMapRequest *request = [[CZOpenWeatherMapRequest alloc]initWithFeature:@"history/city"];
    request.start = from;
    request.end = to;
    return request;
}

- (instancetype)initWithFeature:(NSString *)feature
{
    if (self = [super _init]) {
        self.feature = feature;
    }
    return self;
}

#pragma mark CZWeatherRequest

- (void)sendWithCompletion:(CZWeatherRequestCompletion)completion
{
    [self dispatchWithAPI:self.API
               completion:completion];
}

- (Class)API
{
    return [CZOpenWeatherMapAPI class];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZOpenWeatherMapRequest *copy = [[CZOpenWeatherMapRequest alloc]_init];
    copy.feature = [self.feature copy];
    copy.language = [self.language copy];
    copy.location = [self.location copy];
    copy.start = [self.start copy];
    copy.end = [self.end copy];
    copy.key = [self.key copy];
    copy.days = self.days;
    return copy;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super _init]) {
        self.location = [aDecoder decodeObjectOfClass:[CZWeatherLocation class] forKey:@"location"];
        self.language = [aDecoder decodeObjectOfClass:[NSString class]
                                               forKey:@"language"];
        self.feature = [aDecoder decodeObjectOfClass:[NSString class]
                                              forKey:@"feature"];
        self.days = [aDecoder decodeIntegerForKey:@"days"];
        self.start = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"start"];
        self.end = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"end"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.feature forKey:@"feature"];
    [aCoder encodeObject:self.start forKey:@"start"];
    [aCoder encodeObject:self.end forKey:@"end"];
    [aCoder encodeInteger:self.days forKey:@"days"];
}

@end
