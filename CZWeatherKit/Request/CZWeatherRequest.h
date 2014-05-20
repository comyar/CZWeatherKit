//
//  CZWeatherRequest.h
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

@import Foundation;
@import CoreLocation;
#import "CZWeatherService.h"


#pragma mark - Forward Declarations

@class CZWeatherData;


#pragma mark - Constants

/** 
 Indicates the level of detail being requested for a weather request. Weather services
 define the data each detail level provides.
 */
typedef NS_ENUM(u_int8_t, CZWeatherRequestDetail) {
    /** Indicates that no data is being requested. */
    CZWeatherRequestNoDetail = 0,
    /** Indicates that a minimal amount of data is being requested. */
    CZWeatherRequestLightDetail,
    /** Indicates that the maxmimum amount of data is being requested. */
    CZWeatherRequestFullDetail
};

/**
 Completion handler block type for requests
 */
typedef void (^CZWeatherRequestCompletion) (CZWeatherData *weatherData, NSError *error);

/**
 Error domain for errors passed as arguments to CZWeatherRequestCompletion blocks
 */
extern NSString * const CZWeatherRequestErrorDomain;

 
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
+ (CZWeatherRequest *)request;

// -----
// @name Using a Weather Request
// -----

#pragma mark - Using a Weather Request

/**
 Initiates a weather request. 
 
 In order for a weather request to complete successfully, the location and service
 must not be nil. Otherwise, the request completes immediately and an error is passed
 to the completion handler. 
 
 If both conditionsDetail and forecastDetail are CZWeatherRequestNoDetail, the request
 completes immediately and both the weatherData and error arguments to the completion 
 handler will be nil.
 
 Changing a request's properties once the request has started is undefined.
 */
- (void)start;

// -----
// @name Properties
// -----

#pragma mark - Properties

/**
 Location to request weather data for.
 */
@property (nonatomic) CLLocation                            *location;

/**
 Service to use when requesting and parsing data. 
 
 Services must adopt the CZWeatherService protocol.
 */
@property (nonatomic) id<CZWeatherService>                  service;

/**
 Indicates the detail level for current conditions data.
 
 Default is CZWeatherRequestNoDetail.
 */
@property (nonatomic) CZWeatherRequestDetail                conditionsDetail;

/**
 Indicates the detail level for forecast data.
 
 Default is CZWeatherRequestNoDetail.
 */
@property (nonatomic) CZWeatherRequestDetail                forecastDetail;

/**
 Completion handler block.
 */
@property (nonatomic, strong) CZWeatherRequestCompletion    completionHandler;

@end
