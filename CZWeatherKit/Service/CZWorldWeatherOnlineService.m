//
//  CZWorldWeatherOnlineService.m, Created by Sebastian Jachec
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
#import "CZWorldWeatherOnlineService.h"
#import "CZWeatherCondition.h"
#import "CZWeatherRequest.h"


#pragma mark - Constants

// Base URL
static NSString * const base        = @"http://api.worldweatheronline.com/free/v1/weather.ashx";

// Name of the service
static NSString * const serviceName = @"World Weather Online";


#pragma mark - CZWorldWeatherOnlineService Implementation

@implementation CZWorldWeatherOnlineService
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
    return [[CZWorldWeatherOnlineService alloc]initWithKey:key];
}

#pragma mark Using a Weather Service

- (NSURL *)urlForRequest:(CZWeatherRequest *)request
{
    if (self.key.length == 0) {
        return nil;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&format=json&includelocation=no&show_comments=no", base, self.key];
    
    if (request.location.locationType == CZWeatherLocationCoordinateType) {
        CGPoint coordinate = [request.location.locationData[CZWeatherLocationCoordinateName]CGPointValue];
        url = [url stringByAppendingFormat:@"&q=%.4f%%2C%.4f", coordinate.x, coordinate.y];
        
    } else if (request.location.locationType == CZWeatherLocationCityStateType) {
        NSString *city = request.location.locationData[CZWeatherLocationCityName];
        city = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *state = request.location.locationData[CZWeatherLocationStateName];
        
        url = [url stringByAppendingFormat:@"&q=%@%%2C%@", city, state];
        
    } else if (request.location.locationType == CZWeatherLocationCityCountryType) {
        NSString *city = request.location.locationData[CZWeatherLocationCityName];
        city = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *country = request.location.locationData[CZWeatherLocationCountryName];
        country = [country stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [url stringByAppendingFormat:@"&q=%@%%2C%@", city, country];
        
    } else if (request.location.locationType == CZWeatherLocationZipcodeType) {
        NSString *zipcode = request.location.locationData[CZWeatherLocationZipcodeName];
        zipcode = [zipcode stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        url = [url stringByAppendingFormat:@"&q=%@",zipcode];
        
    } else {
        return nil;
    }
    
    if (request.requestType == CZCurrentConditionsRequestType) {
        url = [url stringByAppendingString:@"&num_of_days=1&fx=yes&cc=yes"];
    } else {
        url = [url stringByAppendingString:@"&num_of_days=5&fx=yes&cc=no"];
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

#pragma mark Helpers

- (CZWeatherCondition *)parseCurrentConditionsFromJSON:(NSDictionary *)JSON
{
    CZWeatherCondition *condition = [CZWeatherCondition new];
    
    NSDictionary *currentObservation = JSON[@"data"][@"current_condition"][0];
    
    condition.date = [self dateFromTime:currentObservation[@"observation_time"]];
    condition.summary = currentObservation[@"weatherDesc"][0][@"value"];
    condition.climaconCharacter = [self climaconCharacterForWeatherCode:[currentObservation[@"weatherCode"]intValue]];
    
    condition.temperature = (CZTemperature){[currentObservation[@"temp_F"]floatValue], [currentObservation[@"temp_C"]floatValue]};
    
    NSDictionary *weather = JSON[@"data"][@"weather"][0];
    condition.lowTemperature = (CZTemperature){[weather[@"tempMinF"]floatValue], [weather[@"tempMinC"]floatValue]};
    condition.highTemperature = (CZTemperature){[weather[@"tempMaxF"]floatValue], [weather[@"tempMaxC"]floatValue]};
    
    condition.windDegrees = [currentObservation[@"winddirDegree"]floatValue];
    condition.windSpeed = (CZWindSpeed){[currentObservation[@"windspeedMiles"]floatValue], [currentObservation[@"windspeedKmph"]floatValue]};
    condition.humidity = [currentObservation[@"humidity"]floatValue];
    
    return condition;
}

- (NSDate*)dateFromTime:(NSString*)timeStr {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *time = [dateFormatter dateFromString:timeStr];
    
    NSDateComponents *timeComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:time];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    components.hour = timeComponents.hour;
    components.minute = timeComponents.minute;
    
    return [calendar dateFromComponents:components];
}

- (NSArray *)parseForecastFromJSON:(NSDictionary *)JSON forDetailLevel:(CZWeatherRequestDetailLevel)detailLevel
{
    NSMutableArray *forecastConditions = [NSMutableArray new];
    
    NSArray *forecasts = JSON[@"data"][@"weather"];
    
    for (NSDictionary *forecast in forecasts) {
        CZWeatherCondition *condition = [CZWeatherCondition new];
        
        condition.lowTemperature = (CZTemperature){[forecast[@"tempMinF"]floatValue], [forecast[@"tempMinC"]floatValue]};
        condition.highTemperature = (CZTemperature){[forecast[@"tempMaxF"]floatValue], [forecast[@"tempMaxC"]floatValue]};
        condition.windDegrees = [forecast[@"winddirDegree"]floatValue];
        condition.windSpeed = (CZWindSpeed){[forecast[@"windspeedMiles"]floatValue], [forecast[@"windspeedKmph"]floatValue]};
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        condition.date = [dateFormatter dateFromString:forecast[@"date"]];
        
        condition.summary = forecast[@"weatherDesc"][0][@"value"];
        
        condition.climaconCharacter = [self climaconCharacterForWeatherCode:[forecast[@"weatherCode"]intValue]];
        
        [forecastConditions addObject:condition];
    }
    
    return [forecastConditions copy];
}

- (Climacon)climaconCharacterForWeatherCode:(int)code
{
    if ([@[@395, @392, @374, @371, @368, @350, @338, @335, @332, @329, @326, @323, @230, @179, @227] containsObject:@(code)]) {
        return ClimaconSnow;
    } else if ([@[@365, @362, @320, @317, @182] containsObject:@(code)]) {
        return ClimaconSleet;
    } else if ([@[@389, @386, @356, @314, @311, @308, @305, @302, @299, @176] containsObject:@(code)]) {
        return ClimaconRain;
    } else if ([@[@296, @203, @284, @281, @266, @263, @185] containsObject:@(code)]) {
        return ClimaconDrizzle;
    } else if (code == 359) {
        return ClimaconDownpour;
    } else if (code == 377 || code == 353) {
        return ClimaconShowers;
    } else if (code == 260 || code == 248 || code == 200 || code == 143) {
        return ClimaconFog;
    } else if (code == 122 || code == 119) {
        return ClimaconCloud;
    } else if (code == 116) {
        return ClimaconCloudSun;
    }
    
    //113
    return ClimaconSun;
}

@end