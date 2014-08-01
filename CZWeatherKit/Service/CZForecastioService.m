//
//  CZForecastioService.h, Created by Sebastian Jachec
//  Copyright (c) 2014, Comyar Zaheri, http://comyar.io
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#pragma mark - Imports
#import "NSString+CZWeatherKit_Substring.h"
#import "CZWeatherService_Internal.h"
#import "CZMacros.h"
#import "CZForecastioService.h"
#import "CZWeatherCondition.h"
#import "CZWeatherRequest.h"


#pragma mark - Constants

// Base URL
static NSString * const base        = @"https://api.forecast.io/forecast";

// Name of the service
static NSString * const serviceName = @"Forecast.io";


#pragma mark - CZForecastioService Implementation

@implementation CZForecastioService
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
    return [[CZForecastioService alloc]initWithKey:key];
}

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    if (self.key.length == 0) {
        return nil;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/", base, self.key];
    
    if (request.location.locationType == CZWeatherLocationCoordinateType) {
        CGPoint coordinate = [request.location.locationData[CZWeatherLocationCoordinateName]CGPointValue];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%.4f,%.4f", coordinate.x, coordinate.y]];
    } else {
        return nil;
    }
    
    if (request.requestType == CZCurrentConditionsRequestType) {
        url = [url stringByAppendingString:@"?exclude=minutely,hourly,daily,alerts,flags"];
    }else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestLightDetail) {
        url = [url stringByAppendingString:@"?exclude=minutely,currently,daily,alerts,flags"];
    } else if (request.requestType == CZForecastRequestType && request.detailLevel == CZWeatherRequestFullDetail) {
        url = [url stringByAppendingString:@"?exclude=minutely,currently,hourly,alerts,flags"];
    }
    
    if ([request.language length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&lang=%@", request.language]];
    }
    
    return [NSURL URLWithString:url];
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
        return [self parseForecastFromJSON:JSON forDetailLevel:request.detailLevel];
    }
    
    return nil;
}

#pragma mark Helper

- (CZWeatherCondition *)parseCurrentConditionsFromJSON:(NSDictionary *)JSON
{
    CZWeatherCondition *condition = [CZWeatherCondition new];
    
    NSDictionary *currentObservation = JSON[@"currently"];
    
    NSTimeInterval epoch = [currentObservation[@"time"]doubleValue];
    condition.date = [NSDate dateWithTimeIntervalSince1970:epoch];
    condition.summary = currentObservation[@"summary"];
    condition.climaconCharacter = [self climaconCharacterForDescription:currentObservation[@"icon"]];
    
    CGFloat tempF = [currentObservation[@"temperature"]floatValue];
    condition.temperature = (CZTemperature){tempF, F_TO_C(tempF)};
    
    condition.windDegrees = [currentObservation[@"windBearing"]floatValue];
    
    CGFloat windSpeedMPH = [currentObservation[@"windSpeed"]floatValue];
    condition.windSpeed = (CZWindSpeed){windSpeedMPH, MPH_TO_KPH(windSpeedMPH)};
    
    condition.humidity = [currentObservation[@"humidity"]floatValue];
    
    return condition;
}

- (NSArray *)parseForecastFromJSON:(NSDictionary *)JSON forDetailLevel:(CZWeatherRequestDetailLevel)detailLevel
{
    NSMutableArray *forecastConditions = [NSMutableArray new];
    
    NSArray *forecasts = (detailLevel==CZWeatherRequestLightDetail)? JSON[@"hourly"][@"data"] : JSON[@"daily"][@"data"];
    
    for (NSDictionary *forecast in forecasts) {
        CZWeatherCondition *condition = [CZWeatherCondition new];
        
        if (detailLevel == CZWeatherRequestLightDetail) {
            CGFloat tempF = [forecast[@"temperature"]floatValue];
            condition.temperature = (CZTemperature){tempF, F_TO_C(tempF)};
            
            condition.windDegrees = [forecast[@"windBearing"]floatValue];
            
            CGFloat windSpeedMPH = [forecast[@"windSpeed"]floatValue];
            condition.windSpeed = (CZWindSpeed){windSpeedMPH, MPH_TO_KPH(windSpeedMPH)};
            
            condition.humidity = [forecast[@"humidity"]floatValue];
            
        } else if (detailLevel == CZWeatherRequestFullDetail) {
            CGFloat highTempF = [forecast[@"temperatureMax"]floatValue];
            condition.highTemperature = (CZTemperature){highTempF, F_TO_C(highTempF)};
            
            CGFloat lowTempF = [forecast[@"temperatureMin"]floatValue];
            condition.lowTemperature = (CZTemperature){lowTempF, F_TO_C(lowTempF)};
            
            condition.humidity = [forecast[@"humidity"]floatValue];
            
            CGFloat windSpeedMPH = [forecast[@"windSpeed"]floatValue];
            condition.windSpeed = (CZWindSpeed){windSpeedMPH, MPH_TO_KPH(windSpeedMPH)};
            
            condition.windDegrees = [forecast[@"windBearing"]floatValue];
        }
        
        condition.summary = forecast[@"summary"];
        
        condition.date = [NSDate dateWithTimeIntervalSince1970:[forecast[@"time"]doubleValue]];
        
        condition.climaconCharacter = [self climaconCharacterForDescription:forecast[@"icon"]];
        
        [forecastConditions addObject:condition];
    }
    
    return [forecastConditions copy];
}

- (Climacon)climaconCharacterForDescription:(NSString *)description
{
    Climacon icon = ClimaconSun;
    NSString *lowercaseDescription = description.lowercaseString;
    
    if([lowercaseDescription cz_contains:@"clear"]) {
        icon = ClimaconSun;
    } else if([lowercaseDescription cz_contains:@"cloudy"]) {
        icon = ClimaconCloud;
    } else if([lowercaseDescription cz_contains:@"partly-cloudy-day"]) {
        icon = ClimaconCloudSun;
    } else if([lowercaseDescription cz_contains:@"partly-cloudy-night"]) {
        icon = ClimaconCloudMoon;
    } else if([lowercaseDescription cz_contains:@"rain"]  ||
              [lowercaseDescription cz_contains:@"thunderstorm"]) {
        icon = ClimaconRain;
    } else if([lowercaseDescription cz_contains:@"sleet"]) {
        icon = ClimaconSleet;
    } else if([lowercaseDescription cz_contains:@"hail"]) {
        icon = ClimaconHail;
    }else if([lowercaseDescription cz_contains:@"snow"]) {
        icon = ClimaconSnow;
    } else if([lowercaseDescription cz_contains:@"wind"]) {
        icon = ClimaconWind;
    } else if([lowercaseDescription cz_contains:@"fog"]) {
        icon = ClimaconFog;
    }
    return icon;
}

@end