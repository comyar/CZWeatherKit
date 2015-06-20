//
//  CZWeatherService.h
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

@import Foundation;


#pragma mark - Forward Declarations

@protocol CZWeatherDataCache;

@class CZWeatherData;
@class CZWeatherRequest;
@class CZWeatherService;


#pragma mark - Type Definitions

/**
 Completion handler for dispatched requests.
 
 @param     data
            The weather data for the request. May be nil if the request was 
            invalid or the weather service was unable to fulfill the request.
 @param     error   
            An error if one occurred, or nil. Currently unused.
 */
typedef void (^CZWeatherServiceCompletion)(CZWeatherData *data, NSError *error);

/**
 Completion handler for dispatched batch of requests.
 
 @param     data
            An array of CZWeatherData and/or NSNull objects whose indices
            in the array match the indices of their corresponding requests. The
            array is never nil.
 @param     error
            An error if one occurred, or nil. Currently unused.
 */
typedef void (^CZWeatherServiceBatchCompletion)(NSArray *data, NSError *error);


#pragma mark - CZWeatherService Interface

/**
 A weather service allows for the dispatching of weather data requests and 
 allows for finer-grain control over how requests are handled as opposed to the
 interface provided by CZWeatherDataRequest.
 
 Use a weather service if you want to provide your own URL session
 configuration or a cache to store weather data. If neither of these features
 is needed, simply using CZWeatherDataRequest's sendWithAPI:completion:
 should be sufficient.
 */
@interface CZWeatherService : NSObject

// -----
// @name Creating a Weather Service
// -----

#pragma mark Creating a Weather Service

/**
 Initializes a weather service.
 
 The default NSURLSessionConfiguration will be used.
 
 @return    A newly initialized weather service.
 */
- (instancetype)init;

/**
 Initializes a weather service using the given configuration.
 
 @param     configuration
            The URL session configuration to use.
 @return    A newly initialized weather service.
 */
- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 Initializes a weather service using the given configuration and key.
 
 @param     configuration
            The URL session configuration to use.
 @param     key
            The API key to use.
 @return    A newly initialized weather service.
 */
- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
                                  key:(NSString *)key;

/**
 Initializes a weather service using the given configuration, key, and cache.
 
 @param     configuration
            The URL session configuration to use.
 @param     key
            The API key to use.
 @param     cache
            The weather data cache to use.
 @return    A newly initialized weather service.
 */
- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
                                  key:(NSString *)key
                                cache:(id<CZWeatherDataCache>)cache
                                    NS_DESIGNATED_INITIALIZER;

/**
 Creates and initializes a new weather service.
 
 The default NSURLSessionConfiguration will be used.
 
 @return    A newly created weather service.
 */
+ (instancetype)service;

/**
 Creates and initializes a weather service using the given configuration.
 
 @param     configuration
            The URL session configuration to use.
 @return    A newly created weather service.
 */
+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 Creates and initializes a weather service using the given configuration and key.
 
 @param     configuration
            The URL session configuration to use.
 @param     key
            The API key to use.
 @return    A newly created weather service.
 */
+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration
                                     key:(NSString *)key;

/**
 Creates and initializes a weather service using the given configuration, key, and cache.
 
 @param     configuration
            The URL session configuration to use.
 @param     key
            The API key to use.
 @param     cache
            The weather data cache to use.
 @return    A newly created weather service.
 */
+ (instancetype)serviceWithConfiguration:(NSURLSessionConfiguration *)configuration
                                     key:(NSString *)key
                                   cache:(id<CZWeatherDataCache>)cache;

// -----
// @name Using a Weather Service
// -----

#pragma mark Using a Weather Service

/**
 Asynchronously dispatches the given request.
 
 @param     request
            The request to dispatch.
 @param     completion
            The completion handler for the request.
 @warning   The completion handler is not guaranteed to be executed on any 
            specific queue. If you are updating any user interface elements in 
            the completion handler, you must explictly perform the updates on
            the main queue.
 */
- (void)dispatchRequest:(CZWeatherRequest *)request
             completion:(CZWeatherServiceCompletion)completion;

/**
 Asynchronously dispatches the given requests.
 
 The completion handler is executed when all of the given requests complete. Use
 this method if your app requires multiple requests to retrieve data. For 
 example, one use case would be if you require both current weather data and
 forecasted weather data before updating your user interface.
 
 @param     requests
            The requests to dispatch.
 @param     completion
            The completion handler for the requests.
 @warning   The completion handler is not guaranteed to be executed on any
            specific queue. If you are updating any user interface elements in
            the completion handler, you must explictly perform the updates on
            the main queue.
 */
- (void)dispatchRequests:(NSArray *)requests
              completion:(CZWeatherServiceBatchCompletion)completion;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The default API key to use for requests.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSString *key;

/**
 The cache used by the weather service.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) id<CZWeatherDataCache> cache;

/**
 The URL session configuration used by the weather service.
 */
@property (readonly, NS_NONATOMIC_IOSONLY) NSURLSessionConfiguration *configuration;

@end
