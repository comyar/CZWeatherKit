//
//  CZWeatherService.m
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

#import "CZWeatherService.h"

#import "CZWeatherAPI.h"
#import "CZWeatherRequest.h"
#import "CZWeatherDataCache.h"
#import "CZWeatherKitInternal.h"


#pragma mark - CZWeatherService Class Extension

@interface CZWeatherService ()

@property (NS_NONATOMIC_IOSONLY) NSString *key;
@property (NS_NONATOMIC_IOSONLY) NSURLSession *session;
@property (NS_NONATOMIC_IOSONLY) dispatch_queue_t queue;
@property (NS_NONATOMIC_IOSONLY) id<CZWeatherDataCache> cache;
@property (NS_NONATOMIC_IOSONLY) NSURLSessionConfiguration *configuration;

@end


#pragma mark - CZWeatherService Implementation

@implementation CZWeatherService

#pragma mark Creating a Weather Service

- (instancetype)init
{
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    return [self initWithConfiguration:configuration
                                   key:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
                                  key:(NSString *)key
{
    return [self initWithConfiguration:configuration
                                   key:key
                                 cache:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
                                  key:(NSString *)key
                                cache:(id<CZWeatherDataCache>)cache
{
    if (self = [super init]) {
        self.key = key;
        self.cache = cache;
        self.configuration = configuration ? configuration : [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:self.configuration];
        NSString *queue = [NSString stringWithFormat:@"com.czweatherkit.CZWeatherService.%p", self];
        self.queue = dispatch_queue_create([queue UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

+ (instancetype)service
{
    return [self new];
}

+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    return [[self alloc]initWithConfiguration:configuration];
}

+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration
                                     key:(NSString *)key
{
    return [[self alloc]initWithConfiguration:configuration
                                          key:key];
}

+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration
                                     key:(NSString *)key
                                   cache:(id<CZWeatherDataCache>)cache
{
    return [[self alloc]initWithConfiguration:configuration
                                          key:key
                                        cache:cache];
}

#pragma mark Using a Weather Service

- (void)dispatchRequest:(CZWeatherRequest *)request
            completion:(CZWeatherServiceCompletion)completion
{
    if (!completion) {
        return;
    } else if(!request) {
        completion(nil, nil); // invalid request
        return;
    }
    
    // copy the request in case the user mutates the original request
    request = [request copy];
    
    __weak CZWeatherService *weak = self;
    dispatch_async(self.queue, ^{
        CZWeatherService *strong = weak;
        if (strong) {
            CZWeatherData *data = [strong handleRequest:request];
            completion(data, nil);
        } else {
            completion(nil, nil);
        }
    });
}

- (void)dispatchRequests:(NSArray *)requests
              completion:(CZWeatherServiceBatchCompletion)completion
{
    NSMutableArray *data = [NSMutableArray new];
    
    if (!completion) {
        return;
    } else if (!requests) {
        completion(data, nil);
        return;
    }
    
    NSMutableArray *copies = [NSMutableArray new];
    for (NSObject *object in requests) {
        if ([object isKindOfClass:[CZWeatherRequest class]]) {
            [copies addObject:[object copy]];
        }
    }
    
    __weak CZWeatherService *weak = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(self.queue, ^{
        for (CZWeatherRequest *request in copies) {
            dispatch_group_enter(group);
            dispatch_async(self.queue, ^{
                CZWeatherService *strong = weak;
                if (strong) {
                    CZWeatherData *weatherData = [strong handleRequest:request];
                    if (weatherData) {
                        [data addObject:weatherData];
                    } else {
                        [data addObject:[NSNull null]];
                    }
                } else {
                    [data addObject:[NSNull null]];
                }
                dispatch_group_leave(group);
            });
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        completion(data, nil);
    });
}

- (CZWeatherData *)handleRequest:(CZWeatherRequest *)request
{
    if (!request.key) {
        request.key = self.key;
    }
    
    CZWeatherData *result = [self cachedWeatherDataForRequest:request];
    if (result) {
        return result;
    }
    
    result = [self remoteWeatherDataForRequest:request];
    if (result) {
        [self.cache storeData:result
                   forRequest:request];
    }
    
    return result;
}

- (CZWeatherData *)cachedWeatherDataForRequest:(CZWeatherRequest *)request
{
    if (self.cache) {
        __block CZWeatherData *cached = nil;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self.cache dataForRequest:request completion:^(CZWeatherData *data) {
            cached = data;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return cached;
    }
    return nil;
}

- (CZWeatherData *)remoteWeatherDataForRequest:(CZWeatherRequest *)request
{
    NSURLRequest *URLRequest = [request.API transformRequest:request];
    if (!URLRequest) {
        return nil;
    }
    
    __block CZWeatherData *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[self.session dataTaskWithRequest:URLRequest
                       completionHandler:^(NSData *data,
                                           NSURLResponse *response,
                                           NSError *error) {
                           result = [request.API transformResponse:response
                                                              data:data
                                                             error:error
                                                        forRequest:request];
                           dispatch_semaphore_signal(semaphore);
                       }]resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

@end
