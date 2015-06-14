//
//  CZPINWeatherDataCache.m
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

#import "CZPINWeatherDataCache.h"
#import "CZWeatherKitInternal.h"
#import "CZWeatherAPI.h"

#import <PINCache/PINCache.h>


#pragma mark - CZPINWeatherDataCache Class Extension

@interface CZPINWeatherDataCache ()

@property (NS_NONATOMIC_IOSONLY) PINCache *cache;

@end


#pragma mark - CZPINWeatherDataCache Implementation

@implementation CZPINWeatherDataCache

- (instancetype)init
{
    if (self = [super init]) {
        self.cache = [[PINCache alloc]initWithName:@"com.czweatherkit.pincache"];
        self.cache.diskCache.ageLimit   = 3600; // one hour
        self.cache.memoryCache.ageLimit = 3600;
    }
    return self;
}

- (void)dataForRequest:(CZWeatherRequest *)request completion:(CZWeatherDataCacheCompletion)completion
{
    NSString *key = [request.API cacheKeyForRequest:request];
    [self.cache objectForKey:key block:^(PINCache *cache, NSString *key, id __nullable object) {
        if ([object isKindOfClass:[CZWeatherData class]]) {
            completion(object);
        } else {
            completion(nil);
        }
    }];
}

- (void)storeData:(CZWeatherData *)data forRequest:(CZWeatherRequest *)request
{
    NSString *key = [request.API cacheKeyForRequest:request];
    [self.cache setObject:data forKey:key block:nil];
}

@end
