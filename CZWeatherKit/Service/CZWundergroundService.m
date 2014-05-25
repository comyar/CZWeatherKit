//
// CZWundergroundService.m
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

#import "NSString+CZWeatherKit_Substring.h"
#import "CZWeatherService_Internal.h"
#import "CZWundergroundService.h"
#import "CZWeatherCondition.h"
#import "CZWeatherRequest.h"


#if !(TARGET_OS_IPHONE)
#define CGPointValue pointValue
#endif


#pragma mark - Constants

// Host for API
static NSString * const host        = @"api.wunderground.com";

// Name of the service
static NSString * const serviceName = @"Weather Underground";


#pragma mark - CZWundergroundService Implementation

@implementation CZWundergroundService
@synthesize key = _key, serviceName = _serviceName;

#pragma mark Creating a Weather Service

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key
{
    if (self = [super init]) {
        _key            = key;
        _serviceName    = serviceName;
    }
    return self;
}

+ (instancetype)serviceWithKey:(NSString *)key
{
    return [[CZWundergroundService alloc]initWithKey:key];
}

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    if ([self.key length] == 0) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents new];
    components.scheme   = @"http";
    components.host     = host;
    components.path     = [NSString stringWithFormat:@"/api/%@/", self.key];
    
    if (request.requestType == CZCurrentConditionsRequestType) {
        components.path = [components.path stringByAppendingString:@"conditions/"];
    }else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestLightDetail) {
        components.path = [components.path stringByAppendingString:@"forecast/"];
    } else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestFullDetail) {
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

- (id)weatherDataForResponseData:(NSData *)data request:(CZWeatherRequest *)request
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    if (!JSON) {
        return nil;
    }
    
    if (request.requestType == CZCurrentConditionsRequestType) {
        return [self parseCurrentConditionsFromJSON:JSON];
    } else if (request.requestType == CZForecastRequestType) {
        return [self parseForecastFromJSON:JSON];
    }
    
    return nil;
}

#pragma mark Helper

- (CZWeatherCondition *)parseCurrentConditionsFromJSON:(NSDictionary *)JSON
{
    CZWeatherCondition *condition = [CZWeatherCondition new];
    
    NSDictionary *currentObservation = JSON[@"current_observation"];
    
    NSTimeInterval epoch = [currentObservation[@"observation_epoch"]doubleValue];
    condition.date = [NSDate dateWithTimeIntervalSince1970:epoch];
    condition.description = currentObservation[@"weather"];
    condition.climaconCharacter = [self climaconCharacterForDescription:condition.description];
    condition.temperature = (CZTemperature){[currentObservation[@"temp_f"]floatValue], [currentObservation[@"temp_c"]floatValue]};
    condition.windDegrees = [currentObservation[@"wind_degrees"]floatValue];
    condition.windSpeed = (CZWindSpeed){[currentObservation[@"wind_mph"]floatValue],[currentObservation[@"wind_kph"]floatValue]};
    condition.humidity = [[currentObservation[@"relative_humidity"]stringByReplacingOccurrencesOfString:@"%" withString:@""]floatValue];
    
    return condition;
}

- (NSArray *)parseForecastFromJSON:(NSDictionary *)JSON
{
    NSMutableArray *forecasts = [NSMutableArray new];
    
    NSArray *forecastDay = JSON[@"forecast"][@"simpleforecast"][@"forecastday"];
    
    for (NSDictionary *day in forecastDay) {
        CZWeatherCondition *condition = [CZWeatherCondition new];
        
        NSTimeInterval epoch = [day[@"date"][@"epoch"]doubleValue];
        condition.date = [NSDate dateWithTimeIntervalSince1970:epoch];
        condition.description = day[@"conditions"];
        condition.highTemperature = (CZTemperature){[day[@"high"][@"fahrenheit"]floatValue], [day[@"high"][@"celsius"]floatValue]};
        condition.lowTemperature = (CZTemperature){[day[@"low"][@"fahrenheit"]floatValue], [day[@"low"][@"celsius"]floatValue]};
        condition.climaconCharacter = [self climaconCharacterForDescription:condition.description];
        condition.humidity = [day[@"avehumidity"]floatValue];
        condition.windSpeed = (CZWindSpeed){[day[@"avewind"][@"mph"]floatValue], [day[@"avewind"][@"kph"]floatValue]};
        condition.windDegrees = [day[@"avewind"][@"degrees"]floatValue];
        [forecasts addObject:condition];
    }
    
    return [forecasts copy];
}

- (Climacon)climaconCharacterForDescription:(NSString *)description
{
    Climacon icon = ClimaconSun;
    NSString *lowercaseDescription = [description lowercaseString];
    
    if([lowercaseDescription contains:@"clear"]) {
        icon = ClimaconSun;
    } else if([lowercaseDescription contains:@"cloud"]) {
        icon = ClimaconCloud;
    } else if([lowercaseDescription contains:@"drizzle"]  ||
              [lowercaseDescription contains:@"rain"]     ||
              [lowercaseDescription contains:@"thunderstorm"]) {
        icon = ClimaconRain;
    } else if([lowercaseDescription contains:@"snow"]     ||
              [lowercaseDescription contains:@"hail"]     ||
              [lowercaseDescription contains:@"ice"]) {
        icon = ClimaconSnow;
    } else if([lowercaseDescription contains:@"fog"]      ||
              [lowercaseDescription contains:@"overcast"] ||
              [lowercaseDescription contains:@"smoke"]    ||
              [lowercaseDescription contains:@"dust"]     ||
              [lowercaseDescription contains:@"ash"]      ||
              [lowercaseDescription contains:@"mist"]     ||
              [lowercaseDescription contains:@"haze"]     ||
              [lowercaseDescription contains:@"spray"]    ||
              [lowercaseDescription contains:@"squall"]) {
        icon = ClimaconHaze;
    }
    return icon;
}

@end
