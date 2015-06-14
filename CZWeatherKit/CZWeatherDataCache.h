//
//  CZWeatherDataCache.h
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


#pragma mark - Forward Declaratiosn

@class CZWeatherData;
@class CZWeatherRequest;


#pragma mark - Type Definitions

/**
 The completion handler for dataForRequest:completion:
 
 @param     data
            The data that was retrieved, or nil if no relevant data was found.
 */
typedef void (^CZWeatherDataCacheCompletion)(CZWeatherData *data);


#pragma mark - CZWeatherDataCache Protocol

/**
 The CZWeatherDataCache protocol declares two methods classes must implement
 to cache weather data retrieved by a weather service. Both methods of the 
 protocol are expected to by asynchronous and non-blocking.
 */
@protocol CZWeatherDataCache <NSObject>

@required

// -----
// @name Using a Weather Data Cache
// -----

#pragma mark Using a Weather Data Cache

/**
 Asynchronously retrieves cached data that is relevant to the provided request.
 
 @param     request
            The request for weather data.
 @param     completion
            The completion handler to use.
 */
- (void)dataForRequest:(CZWeatherRequest *)request
            completion:(CZWeatherDataCacheCompletion)completion;

/**
 Asynchronously stores the provided weather data.
 
 @param     data
            The weather data to store.
 @param     request
            The request for the data.
 */
- (void)storeData:(CZWeatherData *)data
       forRequest:(CZWeatherRequest *)request;

@end
