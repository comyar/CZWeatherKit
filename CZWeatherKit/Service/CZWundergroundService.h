//
//  CZWundergroundService.h
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

@import Foundation;
#import "CZWeatherService.h"


#pragma mark - CZWundergroundService Implementation

/**
 CZWundergroundService is the service object for interfacing with the Wunderground
 developer API. CZWundergroundService adopts the CZWeatherService protocol.
 
 CZWundergroundService should not be subclassed.
 */
@interface CZWundergroundService : NSObject <CZWeatherService>

@end
