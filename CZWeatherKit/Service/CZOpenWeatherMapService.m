//
// CZOpenWeatherMapService.m
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
#import "CZOpenWeatherMapService.h"
#import "CZWeatherCondition.h"
#import "CZWeatherRequest.h"


#if !(TARGET_OS_IPHONE)
#define CGPointValue pointValue
#endif


#pragma mark - Constants

// Host for API
static NSString * const host        = @"api.openweathermap.org";

// Name of the service
static NSString * const serviceName = @"Open Weather Map";

static NSString * const apiVerstion = @"2.5";


#pragma mark - Macros

#define F_TO_C(temp) (5.0/9.0) * (temp - 32.0)
#define MPH_TO_KPH(speed) (speed * 1.609344)

#pragma mark - CZOpenWeatherMapService Implementation

@implementation CZOpenWeatherMapService
@synthesize key = _key, serviceName = _serviceName;

#pragma mark Creating a Weather Service

- (instancetype)init
{
    return [self initWithKey:nil];
}

- (instancetype)initWithKey:(NSString *)key
{
    if (self = [super init]) {
        _key = key;
        _serviceName = serviceName;
    }
    return self;
}

+ (instancetype)serviceWithKey:(NSString *)key
{
    return [[CZOpenWeatherMapService alloc]initWithKey:key];
}

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    NSURLComponents *components = [NSURLComponents new];
    components.scheme   = @"http";
    components.host     = host;
    components.path     = [NSString stringWithFormat:@"/data/%@/", apiVerstion];
    
    if (request.requestType == CZCurrentConditionsRequestType) {
        components.path = [components.path stringByAppendingString:@"weather?"];
    } else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestLightDetail) {
        components.path = [components.path stringByAppendingString:@"forecast/hourly?"];
    } else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestFullDetail) {
        components.path = [components.path stringByAppendingString:@"forecast/daily?"];
    }
    
    if (request.location[CZWeatherKitLocationName.CoordinateName]) {
        CGPoint coordinate = [request.location[CZWeatherKitLocationName.CoordinateName] CGPointValue];
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"lat=%.4f&lon=%.4f", coordinate.x, coordinate.y]];
    } else if (request.location[CZWeatherKitLocationName.StateCityName]) {
        NSString *query = request.location[CZWeatherKitLocationName.StateCityName];
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"q=%@", query]];
    } else if (request.location[CZWeatherKitLocationName.CountryCityName]) {
        NSString *query = request.location[CZWeatherKitLocationName.CountryCityName];
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"q=%@", query]];
    } else {
        return nil;
    }
    
    components.path = [components.path stringByAppendingString:@"&mode=json&units=imperial"];
    
    if ([self.key length] > 0) {
        components.path = [components.path stringByAppendingString:[NSString stringWithFormat:@"&appid=%@", self.key]];
    }
    
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
    
    CGFloat tempF = [JSON[@"main"][@"temp"]floatValue];
    condition.temperature = (CZTemperature){tempF, F_TO_C(tempF)};
    condition.humidity = [JSON[@"main"][@"humidity"]floatValue];
    condition.description = JSON[@"weather"][@"description"];
    condition.climaconCharacter = [self climaconCharacterForDescription:condition.description];
    
    CGFloat windSpeedMPH = [JSON[@"wind"][@"speed"]floatValue];
    condition.windSpeed = (CZWindSpeed){windSpeedMPH, MPH_TO_KPH(windSpeedMPH)};
    condition.windDegrees = [JSON[@"wind"][@"deg"]floatValue];
    
    return condition;
}

- (NSArray *)parseForecastFromJSON:(NSDictionary *)JSON
{
    NSMutableArray *forecastConditions = [NSMutableArray new];
    
    NSArray *forecasts = JSON[@"list"];
    
    for (NSDictionary *forecast in forecasts) {
        CZWeatherCondition *condition = [CZWeatherCondition new];
        
        CGFloat highTempF = [forecast[@"temp"][@"max"]floatValue];
        condition.highTemperature = (CZTemperature){highTempF, F_TO_C(highTempF)};
        
        CGFloat lowTempF = [forecast[@"temp"][@"min"]floatValue];
        condition.lowTemperature = (CZTemperature){lowTempF, F_TO_C(lowTempF)};
        
        condition.humidity = [forecast[@"humidity"]floatValue];
        
        CGFloat windSpeedMPH = [forecast[@"speed"]floatValue];
        condition.windSpeed = (CZWindSpeed){windSpeedMPH, MPH_TO_KPH(windSpeedMPH)};
        
        condition.windDegrees = [forecast[@"deg"]floatValue];
        
        condition.description = forecast[@"weather"][@"description"];
        
        condition.climaconCharacter = [self climaconCharacterForDescription:condition.description];
        
        [forecastConditions addObject:condition];
    }
    
    return [forecastConditions copy];
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
