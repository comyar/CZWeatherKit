//
//  CZWeatherRequest.m
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

#import "CZWeatherRequest.h"


#pragma mark - Constants

NSString * const CZWeatherRequestErrorDomain = @"CZWeatherRequestErrorDomain";


#pragma mark - CZWeatherRequest Class Extension

@interface CZWeatherRequest ()

// YES if the request has started.
@property (nonatomic) BOOL                                  hasStarted;

@end


#pragma mark - CZWeatherRequest Implementation

@implementation CZWeatherRequest

#pragma mark Creating a Weather Request

- (instancetype)init
{
    if (self = [super init]) {
        self.forecastDetail     = CZWeatherRequestNoDetail;
        self.conditionsDetail   = CZWeatherRequestNoDetail;
    }
    return self;
}

+ (CZWeatherRequest *)request
{
    return [CZWeatherRequest new];
}

#pragma mark Using a Weather Request

- (void)start
{
    self.hasStarted = YES;
    
    // Get URL from service
    
    // Send request
    
    // Parse data using service
    
    // Run completion block
}

#pragma mark Setters

- (void)setLocation:(CLLocation *)location
{
    if (!self.hasStarted) {
        _location = location;
    }
}

- (void)setService:(id<CZWeatherService>)service
{
    if (!self.hasStarted) {
        _service = service;
    }
}

- (void)setConditionsDetail:(CZWeatherRequestDetail)conditionsDetail
{
    if (!self.hasStarted) {
        _conditionsDetail = conditionsDetail;
    }
}

- (void)setForecastDetail:(CZWeatherRequestDetail)forecastDetail
{
    if (!self.hasStarted) {
        _forecastDetail = forecastDetail;
    }
}

- (void)setCompletionHandler:(CZWeatherRequestCompletion)completionHandler
{
    if (!self.hasStarted) {
        _completionHandler = completionHandler;
    }
}

@end
