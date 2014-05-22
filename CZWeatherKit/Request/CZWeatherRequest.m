//
//  CZWeatherRequest.m
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

#import "CZWeatherRequest.h"


#pragma mark - Forward Declarations

@class CZWeatherData;


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

// YES if the request has started.
@property (nonatomic) BOOL                                  hasStarted;

@end


#pragma mark - CZWeatherRequest Implementation

@implementation CZWeatherRequest

#pragma mark Creating a Weather Request

- (instancetype)init
{
    if (self = [super init]) {
        _location               = [NSMutableDictionary new];
        self.forecastDetail     = CZWeatherRequestNoDetail;
        self.currentDetail      = CZWeatherRequestNoDetail;
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
    if (self.hasStarted || !self.completionHandler) {
        self.hasStarted = YES;  // Request is considered "started" even it has no completion handler
        return;
    }
    
    if (!self.service) {  // Requests require a service
        self.completionHandler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                        code:CZWeatherRequestConfigurationError
                                                    userInfo:nil]);
    }
    
    NSURL *url = [self.service urlForRequest:self];
    
    if (!url) { // Error if no url provided by service
        self.completionHandler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                        code:CZWeatherRequestServiceURLError
                                                    userInfo:nil]);
    }
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            CZWeatherData *weatherData = [self.service weatherDataForResponseData:data request:self];
            if (weatherData) {
                self.completionHandler(weatherData, nil);
            } else {    // Error if parsing error occurred
                self.completionHandler(nil, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                                code:CZWeatherRequestServiceParseError
                                                            userInfo:nil]);
            }
        } else {
            self.completionHandler(nil, connectionError);
        }
    }];
}

#pragma mark Setters

- (void)setService:(id<CZWeatherService>)service
{
    if (!self.hasStarted) {
        _service = service;
    }
}

- (void)setConditionsDetail:(CZWeatherRequestDetail)conditionsDetail
{
    if (!self.hasStarted) {
        _currentDetail = conditionsDetail;
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
