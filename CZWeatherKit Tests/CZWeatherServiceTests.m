//
//  CZWeatherServiceTests.m
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

@import XCTest;

#import "CZWeatherKit.h"
#import "CZWeatherKitInternal.h"
#import "CZTestWeatherService.h"
#import "CZMemoryWeatherDataCache.h"


#pragma mark - CZWeatherServiceTests Interface

@interface CZWeatherServiceTests : XCTestCase

@end


#pragma mark - CZWeatherServiceTests Implementation

@implementation CZWeatherServiceTests

- (void)testInit
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    CZWeatherService *service = [CZWeatherService serviceWithConfiguration:configuration
                                                                       key:@"key"
                                                                     cache:cache];
    XCTAssertEqual(cache, service.cache);
    XCTAssertEqualObjects(@"key", service.key);
    XCTAssertEqual(configuration, service.configuration);
}

- (void)testCachedWeatherData
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZWeatherService *service = [CZWeatherService serviceWithConfiguration:nil
                                                                       key:nil
                                                                     cache:cache];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZForecastioRequest *request = [CZForecastioRequest newForecastRequest];
    CZWeatherData *weatherData = [CZForecastioAPI transformResponse:nil
                                                               data:data
                                                              error:nil
                                                         forRequest:nil];
    [cache storeData:weatherData forRequest:request];
    
    CZWeatherData *cachedData = [service cachedWeatherDataForRequest:request];
    
    XCTAssertNotNil(cachedData);
}

- (void)testHandleRequestCache
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZWeatherService *service = [CZWeatherService serviceWithConfiguration:nil
                                                                       key:@"key"
                                                                     cache:cache];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZForecastioRequest *cachedRequest = [CZForecastioRequest newForecastRequest];
    cachedRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    cachedRequest.key = @"key";
    
    CZWeatherData *cachedWeatherData = [CZForecastioAPI transformResponse:nil
                                                                     data:data
                                                                    error:nil
                                                               forRequest:nil];
    [cache storeData:cachedWeatherData forRequest:cachedRequest];
    
    XCTAssertNotNil([service handleRequest:cachedRequest]);
}

- (void)testHandleRequestRemote
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZTestWeatherService *service = [CZTestWeatherService serviceWithConfiguration:nil
                                                                               key:@"key"
                                                                             cache:cache];
    
    CZOpenWeatherMapRequest *remoteRequest = [CZOpenWeatherMapRequest newCurrentRequest];
    remoteRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    
    service.remoteBlock = ^ CZWeatherData * (CZWeatherRequest *request) {
        XCTAssertEqualObjects(@"key", request.key);
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"openweathermap_current"
                                          ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [CZOpenWeatherMapAPI transformResponse:nil
                                                 data:data
                                                error:nil
                                           forRequest:request];
    };
    
    XCTAssertNotNil([service handleRequest:remoteRequest]);
    remoteRequest.key = @"key";
    XCTAssertNotNil([service cachedWeatherDataForRequest:remoteRequest]);
}

- (void)testDispatchRequestCache
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZWeatherService *service = [CZWeatherService serviceWithConfiguration:nil
                                                                       key:@"key"
                                                                     cache:cache];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CZForecastioRequest *cachedRequest = [CZForecastioRequest newForecastRequest];
    cachedRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    cachedRequest.key = @"key";
    
    CZWeatherData *cachedWeatherData = [CZForecastioAPI transformResponse:nil
                                                                     data:data
                                                                    error:nil
                                                               forRequest:nil];
    [cache storeData:cachedWeatherData forRequest:cachedRequest];
    
    __block CZWeatherData *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [service dispatchRequest:cachedRequest completion:^(CZWeatherData *data, NSError *error) {
        result = data;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    XCTAssertNotNil(result);
}

- (void)testDispatchRequestRemote
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZTestWeatherService *service = [CZTestWeatherService serviceWithConfiguration:nil
                                                                               key:@"key"
                                                                             cache:cache];
    
    CZOpenWeatherMapRequest *remoteRequest = [CZOpenWeatherMapRequest newCurrentRequest];
    remoteRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    
    service.remoteBlock = ^ CZWeatherData * (CZWeatherRequest *request) {
        XCTAssertEqualObjects(@"key", request.key);
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"openweathermap_current"
                                          ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [CZOpenWeatherMapAPI transformResponse:nil
                                                 data:data
                                                error:nil
                                           forRequest:request];
    };
    
    __block CZWeatherData *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [service dispatchRequest:remoteRequest completion:^(CZWeatherData *data, NSError *error) {
        result = data;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    XCTAssertNotNil(result);
    
    remoteRequest.key = @"key";
    XCTAssertNotNil([service cachedWeatherDataForRequest:remoteRequest]);
}

- (void)testDispatchRequests
{
    CZMemoryWeatherDataCache *cache = [CZMemoryWeatherDataCache new];
    CZTestWeatherService *service = [CZTestWeatherService serviceWithConfiguration:nil
                                                                               key:@"key"
                                                                             cache:cache];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"forecastio_current"
                                      ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CZForecastioRequest *cachedRequest = [CZForecastioRequest newForecastRequest];
    cachedRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    cachedRequest.key = @"key";
    CZWeatherData *cachedWeatherData = [CZForecastioAPI transformResponse:nil
                                                                     data:data
                                                                    error:nil
                                                               forRequest:nil];
    [cache storeData:cachedWeatherData forRequest:cachedRequest];
    
    CZOpenWeatherMapRequest *remoteRequest = [CZOpenWeatherMapRequest newCurrentRequest];
    remoteRequest.location = [CZWeatherLocation locationFromLatitude:47.6097 longitude:-122.3331];
    
    service.remoteBlock = ^ CZWeatherData * (CZWeatherRequest *request) {
        XCTAssertEqualObjects(@"key", request.key);
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"openweathermap_current"
                                          ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        return [CZOpenWeatherMapAPI transformResponse:nil
                                                 data:data
                                                error:nil
                                           forRequest:request];
    };
    
    __block NSArray *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [service dispatchRequests:@[cachedRequest, remoteRequest] completion:^(NSArray *data, NSError *error) {
        result = data;
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    XCTAssertEqual(2, [result count]);
    XCTAssertNotEqualObjects([NSNull null], result[0]);
    XCTAssertNotEqualObjects([NSNull null], result[1]);
    
    remoteRequest.key = @"key";
    XCTAssertNotNil([service cachedWeatherDataForRequest:remoteRequest]);
}


@end
