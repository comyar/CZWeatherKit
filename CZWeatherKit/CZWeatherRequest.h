//
//  CZWeatherDataRequest.h
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

@protocol CZWeatherAPI;
@protocol CZWeatherFeature;

@class CZWeatherData;
@class CZWeatherLocation;


#pragma mark - Type Definitions

/**
 The completion handler for a weather request.
 
 @param     data
            The weather data that was received, or nil.
 @param     error
            The error, if one is available.
 */
typedef void (^CZWeatherRequestCompletion)(CZWeatherData *data, NSError *error);


#pragma mark - CZWeatherRequest Interface

/**
 CZWeatherRequest is an abstract class for data requests to a weather API.
 
 Requests can send themselves or can be dispatched by a weather service. Use a 
 weather service if you want to provide your own URL session configuration or a 
 cache to store weather data. If neither of these features is needed, simply 
 using sendWithAPI:completion: should be sufficient.
 */
@interface CZWeatherRequest : NSObject <NSCopying, NSSecureCoding, NSCoding>

- (instancetype)init NS_UNAVAILABLE;

// -----
// @name Using a Weather Request
// -----

#pragma mark Using a Weather Request

/**
 Sends the request.
 
 @param     completion      
            The completion handler for the request.
 @warning   The completion handler is not guaranteed to be executed on any
            specific queue. If you are updating any user interface elements in
            the completion handler, you must explictly perform the updates on
            the main queue.
 */
- (void)sendWithCompletion:(CZWeatherRequestCompletion)completion;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 The API key to use when sending the request. This value is not required if
 you are dispatching weather requests using a weather service that was
 initialized using an API key or the weather API does not require an API key.
 */
@property (NS_NONATOMIC_IOSONLY) NSString *key;

/**
 Location for the requested data.
 */
@property (NS_NONATOMIC_IOSONLY) CZWeatherLocation *location;

@end
