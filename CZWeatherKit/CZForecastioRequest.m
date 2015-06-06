//
//  CZForecastioRequest.m
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

#import "CZForecastioRequest.h"
#import "CZWeatherKitInternal.h"
#import "CZForecastioAPI.h"


#pragma mark - CZForecastioRequest Class Extension

@interface CZForecastioRequest ()

@property (NS_NONATOMIC_IOSONLY) NSDate *date;

@end


#pragma mark - CZForecastioRequest Implementation

@implementation CZForecastioRequest

+ (instancetype)newForecastRequest
{
    return [CZForecastioRequest newForecastRequestWithDate:nil];
}

+ (instancetype)newForecastRequestWithDate:(NSDate *)date
{
    return [[CZForecastioRequest alloc]initWithDate:date];
}

- (void)sendWithCompletion:(CZWeatherRequestCompletion)completion
{
    [self dispatchWithAPI:self.API
               completion:completion];
}

- (instancetype)initWithDate:(NSDate *)date
{
    if (self = [super _init]) {
        self.date = date;
    }
    return self;
}

- (Class)API
{
    return [CZForecastioAPI class];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    CZForecastioRequest *copy = [[CZForecastioRequest alloc]_init];
    copy.key = [self.key copy];
    copy.date = [self.date copy];
    copy.language = [self.language copy];
    copy.location = [self.location copy];
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
        self.date = [aDecoder decodeObjectOfClass:[NSDate class]
                                              forKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

@end
