//
// CZWeatherRequest.h
// Copyright (c) 2014, Comyar Zaheri
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#pragma mark - Imports

@import Foundation;
#import "CZWeatherService.h"


#pragma mark - Forward Declarations

@class CZWeatherData;


#pragma mark - Constants

/**
 Error domain for errors passed as arguments to CZWeatherRequestCompletion blocks.
 */
extern NSString * const CZWeatherRequestErrorDomain;

/**
 */
struct CZWeatherKitLocationName {
    /** */
    __unsafe_unretained NSString * const CountryCityName;
    /** */
    __unsafe_unretained NSString * const CoordinateName;
    /** */
    __unsafe_unretained NSString * const StateCityName;
    /** */
    __unsafe_unretained NSString * const ZipcodeName;
    /** */
    __unsafe_unretained NSString * const AutoIPName;
};
extern const struct CZWeatherKitLocationName CZWeatherKitLocationName;


#pragma mark - Type Definitions

/**
 Completion handler block type for requests.
 */
typedef void (^CZWeatherRequestHandler) (id data, NSError *error);

/** 
 Indicates the level of detail being requested for a weather request. Weather services
 define the data each detail level provides.
 */
typedef NS_ENUM(NSInteger, CZWeatherRequestDetail) {
    /** Indicates that the minimum amount of data is being requested. */
    CZWeatherRequestLightDetail = 0,
    /** Indicates that the maxmimum amount of data is being requested. */
    CZWeatherRequestFullDetail
};

/**
 Error codes for errors passed as arguments to CZWeatherRequestCompletion blocks.
 */
typedef NS_ENUM(NSInteger, CZWeatherRequestError) {
    CZWeatherRequestConfigurationError  = -1,
    CZWeatherRequestServiceURLError     = -2,
    CZWeatherRequestServiceParseError   = -3
};

/**
 Request types.
 */
typedef NS_ENUM(NSInteger, CZWeatherRequestType) {
    /** Request type to retrieve current conditions data */
    CZCurrentConditionsRequestType  = 0,
    /** Request type to retrieve forecast data */
    CZForecastRequestType
};

 
#pragma mark - CZWeatherRequest Interface

/**
 CZWeatherRequest completes requests to a weather provider's API. Requests can return data regarding
 both the current conditions and forecast at a specific location.
 */
@interface CZWeatherRequest : NSObject

// -----
// @name Creating a Weather Request
// -----

#pragma mark Creating a Weather Request

/**
 */
+ (CZWeatherRequest *)requestWithType:(CZWeatherRequestType)requestType;

/**
 */
- (instancetype)initWithType:(CZWeatherRequestType)requestType;

// -----
// @name Using a Weather Request
// -----

#pragma mark - Using a Weather Request

/**
 Initiates a weather request. 
 
 In order for a weather request to complete successfully, the service must not be nil. 
 Otherwise, the request completes immediately and an error is passed to the completion handler.
 
 If both conditionsDetail and forecastDetail are CZWeatherRequestNoDetail, the request
 completes immediately and both the weatherData and error arguments to the completion 
 handler will be nil.
 
 Changing a request's properties once the request has started is undefined.
 @param completion Completion handler block
 */
- (void)performRequestWithHandler:(CZWeatherRequestHandler)handler;

// -----
// @name Properties
// -----

#pragma mark - Properties

/**
 Location to request weather data for.
 */
@property (nonatomic, readonly) NSMutableDictionary         *location;

/**
 Service to use when requesting and parsing data. 
 
 Services must adopt the CZWeatherService protocol.
 */
@property (nonatomic) id<CZWeatherService>                  service;

/**
 */
@property (nonatomic) CZWeatherRequestType                  requestType;

/**
 */
@property (nonatomic) CZWeatherRequestDetail                detailLevel;

@end
