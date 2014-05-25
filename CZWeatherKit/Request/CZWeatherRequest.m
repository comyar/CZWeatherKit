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

// 
const struct CZWeatherKitLocationName CZWeatherKitLocationName = {
    .CountryCityName    = @"CZWeatherLocationCountryCityName",
    .CoordinateName     = @"CZWeatherLocationCoordinateName",
    .StateCityName      = @"CZWeatherLocationStateCityName",
    .ZipcodeName        = @"CZWeatherLocationZipcodeName",
    .AutoIPName         = @"CZWeatherLocationAutoIPName"
};

// Error domain for errors passed as arguments to CZWeatherRequestCompletion blocks.
NSString * const CZWeatherRequestErrorDomain = @"CZWeatherRequestErrorDomain";


#pragma mark - CZWeatherRequest Class Extension

@interface CZWeatherRequest ()

@end


#pragma mark - CZWeatherRequest Implementation

@implementation CZWeatherRequest

#pragma mark Creating a Weather Request

- (instancetype)init
{
    return [self initWithType:CZCurrentConditionsRequestType];
}

- (instancetype)initWithType:(CZWeatherRequestType)requestType
{
    if (self = [super init]) {
        _location               = [NSMutableDictionary new];
        _detailLevel            = CZWeatherRequestLightDetail;
        _requestType            = requestType;
    }
    return self;
}


+ (CZWeatherRequest *)requestWithType:(CZWeatherRequestType)requestType
{
    return [[CZWeatherRequest alloc]initWithType:requestType];
}

#pragma mark Using a Weather Request

- (void)performRequestWithHandler:(CZWeatherRequestHandler)handler
{
    if (!handler) {
        return;
    }
    
    if (!self.service) { // Requests require a service
        handler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                         code:CZWeatherRequestConfigurationError
                                     userInfo:nil]);
        return;
    }

     __weak CZWeatherRequest *weakRequest = self;
    NSURL *url = [self.service urlForRequest:weakRequest];
    
    if (!url) { // Error if no url provided by service
        handler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                         code:CZWeatherRequestServiceURLError
                                     userInfo:nil]);
        return;
    }
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            id weatherData = [self.service weatherDataForResponseData:data request:weakRequest];
            if (weatherData) {
                handler(weatherData, nil);
            } else {    // Error if parsing failed
                handler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                 code:CZWeatherRequestServiceParseError
                                             userInfo:nil]);
            }
        } else {
            handler(nil, connectionError);
        }
    }];
}

@end
