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

static NSString * const host = @"api.wunderground.com";

#pragma mark - CZWundergroundService Implementation

@implementation CZWundergroundService
@synthesize key = _key;

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    if (!self.key) {    // Wunderground API requires key
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents new];
    components.scheme   = @"http";
    components.host     = host;
    components.path     = [NSString stringWithFormat:@"api/%@/", self.key];
    
    if (request.conditionsDetail != CZWeatherRequestNoDetail) {
        components.path = [components.path stringByAppendingString:@"conditions/"];
    }
    
    if (request.forecastDetail == CZWeatherRequestLightDetail) {
        components.path = [components.path stringByAppendingString:@"forecast/"];
    } else if (request.forecastDetail == CZWeatherRequestFullDetail) {
        components.path = [components.path stringByAppendingString:@"forecast10/"];
    }
    
    components.path = [components.path stringByAppendingString:@"q/"];
    
    if (request.location[CZWeatherKitLocationName.CoordinateName]) {
        CGPoint coordinate = [request.location[CZWeatherKitLocationName.CoordinateName] CGPointValue];
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"%f,%f", coordinate.x, coordinate.y]];
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
    return nil;
}

@end
