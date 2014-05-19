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

//
@property (nonatomic) BOOL                          hasStarted;

//
@property (nonatomic) CZWeatherRequestCompletion    completion;

@end


#pragma mark - CZWeatherRequest Implementation

@implementation CZWeatherRequest

- (void)completion:(CZWeatherRequestCompletion)completion
{
    if (!self.hasStarted) {
        self.completion = completion;
    }
}

- (void)start
{
    self.hasStarted = YES;
    
    // Get URL from service
    
    // Send request
    
    // Parse data using service
    
    // Run completion block
}


@end
