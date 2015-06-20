//
//  CZWeatherAPI.h
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

@class CZWeatherData;
@class CZWeatherRequest;


#pragma mark - CZWeatherAPI Protocol

/**
 The CZWeatherAPI protocol declares two methods that weather API classes must 
 implement to transform requests and responses. This capability allows API
 classes to act as middlemen between CZWeatherKit and the URL Loading System.
 */
@protocol CZWeatherAPI <NSObject>

@required

// -----
// @name Using a Weather API
// -----

#pragma mark Using a Weather API

/**
 Returns a cache key for the given request.
 
 Calls to this method with the same or an equivalent request object must return
 the same cache key.
 
 @param     request
            The request to create a cache key for.
 @return    The cache key for the given request.
 */
+ (NSString *)cacheKeyForRequest:(CZWeatherRequest *)request;

/**
 Transforms a CZWeatherRequest into an NSURLRequest.
 
 @param     request
            The request to transform.
 @return    An NSURLRequest that represents the CZWeatherRequest.
 */
+ (NSURLRequest *)transformRequest:(CZWeatherRequest *)request;

/**
 Transforms an API response into a CZWeatherData object.
 
 @param     response
            The URL response.
 @param     data
            The data included in the response.
 @param     error
            The error, if one occurred.
 @param     request 
            The request that resulted in the response.
 @return    A CZWeatherData object that represents the data included in the
            response.
 */
+ (CZWeatherData *)transformResponse:(NSURLResponse *)response
                                data:(NSData *)data
                               error:(NSError *)error
                          forRequest:(CZWeatherRequest *)request;

@end
