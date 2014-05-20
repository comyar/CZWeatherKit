//
//  CZWundergroundService.m
//  
//
//  Created by Comyar Zaheri on 5/19/14.
//
//


#pragma mark - Imports

#import "CZWundergroundService.h"
#import "CZWeatherRequest.h"
#import "CZWeatherData.h"
#import "CZWeatherData_Friend.h"
#import "CZWeatherState.h"


#pragma mark - Constants

// Host endpoint for API
static NSString * const host = @"api.wunderground.com";

// Name of the service
static NSString * const serviceName = @"Weather Underground";


#pragma mark - CZWundergroundService Implementation

@implementation CZWundergroundService
@synthesize key = _key;

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    if ([self.key length] == 0) {
        return nil;
    }
    
    if (request.conditionsDetail == CZWeatherRequestNoDetail && request.forecastDetail == CZWeatherRequestNoDetail) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents new];
    components.scheme   = @"http";
    components.host     = host;
    components.path     = [NSString stringWithFormat:@"/api/%@/", self.key];
    
    if (request.conditionsDetail != CZWeatherRequestNoDetail) {
        components.path = [components.path stringByAppendingString:@"conditions/"];
    }
    
    if (request.forecastDetail == CZWeatherRequestLightDetail) {
        components.path = [components.path stringByAppendingString:@"forecast/"];
    } else if (request.forecastDetail == CZWeatherRequestFullDetail) {
        components.path = [components.path stringByAppendingString:@"forecast10day/"];
    }
    
    components.path = [components.path stringByAppendingString:@"q/"];
    
    if (request.location[CZWeatherKitLocationName.CoordinateName]) {
        CGPoint coordinate = [request.location[CZWeatherKitLocationName.CoordinateName] CGPointValue];
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"%.4f,%.4f", coordinate.x, coordinate.y]];
    } else if (request.location[CZWeatherKitLocationName.ZipcodeName]) {
        components.path = [components.path stringByAppendingString:request.location[CZWeatherKitLocationName.ZipcodeName]];
    } else if (request.location[CZWeatherKitLocationName.AutoIPName]) {
        components.path = [components.path stringByAppendingString:@"autoip"];
    } else if (request.location[CZWeatherKitLocationName.StateCityName]) {
        components.path = [components.path stringByAppendingString:request.location[CZWeatherKitLocationName.StateCityName]];
    } else if (request.location[CZWeatherKitLocationName.CountryCityName]) {
        components.path = [components.path stringByAppendingString:request.location[CZWeatherKitLocationName.CountryCityName]];
    } else {
        return nil;
    }
    
    components.path = [components.path stringByAppendingString:@".json"];
    
    return [components URL];
}

- (CZWeatherData *)weatherDataForResponseData:(NSData *)data request:(CZWeatherRequest *)request
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (!JSON) {
        return nil;
    }
    
    CZWeatherData *weatherData  = [CZWeatherData new];
    weatherData.location        = [request.location copy];
    weatherData.timestamp       = [NSDate date];
    
    if (request.conditionsDetail != CZWeatherRequestNoDetail) {
        [self parseCurrentConditionsFromJSON:JSON forWeatherData:weatherData];
    }
    
    if (request.forecastDetail != CZWeatherRequestNoDetail) {
        [self parseForecastFromJSON:JSON forWeatherData:weatherData];
    }
    
    return weatherData;
}

- (void)parseCurrentConditionsFromJSON:(NSDictionary *)JSON forWeatherData:(CZWeatherData *)weatherData
{
    CZWeatherState *weatherState = [CZWeatherState new];
}

- (void)parseForecastFromJSON:(NSDictionary *)JSON forWeatherData:(CZWeatherData *)weatherData
{
    NSMutableArray *forecasts = [NSMutableArray new];
    
    NSArray *forecastDay = JSON[@"forecast"][@"simpleforecast"][@"forecastday"];
    
    for (NSDictionary *day in forecastDay) {
        CZWeatherState *weatherState = [CZWeatherState new];
        
        
        
        
        [forecasts addObject:weatherState];
    }
    
    
    weatherData.forecasts = [forecasts copy];
}


#pragma mark Class Methods

+ (NSString *)serviceName
{
    return serviceName;
}

@end
