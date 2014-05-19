//
//  CZWeatherRequest.h
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

@import Foundation;
#import "CZWeatherService.h"

#pragma mark - Forward Declarations

@class CZWeatherData;


#pragma mark - Constants

/** 
 */
typedef NS_ENUM(u_int8t, CZWeatherRequestDetail) {
    /** */
    CZWeatherRequestNoDetail = 0,
    /** */
    CZWeatherRequestLightDetail,
    /** */
    CZWeatherRequestFullDetail
};

/**
 */
typedef void (^CZWeatherRequestCompletion) (CZWeatherData *weatherData, NSError *error);

/**
 */
extern NSString * const CZWeatherRequestErrorDomain;

 
#pragma mark - CZWeatherRequest Interface

/**
 */
@interface CZWeatherRequest : NSObject

// -----
// @name Configuring a Weather Request
// -----

/**
 */
- (void)completion:(CZWeatherRequestCompletion)completion;

// -----
// @name Using a Weather Request
// -----

/**
 */
- (void)start;

// -----
// @name Properties
// -----

#pragma mark - Properties

/**
 */
@property (nonatomic)           id<CZWeatherService>    service;

/**
 */
@property (nonatomic, readonly) CZWeatherRequestDetail  conditionsDetail;

/**
 */
@property (nonatomic, readonly) CZWeatherRequestDetail  forecastDetail;

@end
