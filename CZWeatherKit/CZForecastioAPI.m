//
//  CZForecastIOAPI.m
//  CZWeatherKit
//
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//


#pragma mark - Imports

#import "CZForecastioAPI.h"
#import "CZForecastioRequest.h"
#import "CZWeatherKitInternal.h"


#pragma mark - CZForecastioAPI Implementation

@implementation CZForecastioAPI

+ (NSString *)cacheKeyForRequest:(CZWeatherRequest *)request
{
    return [CZForecastioAPI transformRequest:request].URL.absoluteString;
}

+ (NSURLRequest *)transformRequest:(CZWeatherRequest *)request
{
    if ([request isKindOfClass:[CZForecastioRequest class]]) {
        CZForecastioRequest *forecastioRequest = (CZForecastioRequest *)request;
        
        NSString *location = [CZForecastioAPI componentForLocation:forecastioRequest.location];
        NSString *language = forecastioRequest.language ? forecastioRequest.language : @"en";
        
        NSURLComponents *components = [NSURLComponents new];
        components.scheme = @"https";
        components.host = @"api.forecast.io";
        components.path = [NSString stringWithFormat:@"/forecast/%@/%@",
                           forecastioRequest.key, location];
        if (forecastioRequest.date) {
            NSString *date = [NSString stringWithFormat:@"%ld",
                              (long)[forecastioRequest.date timeIntervalSince1970]];
            components.path = [components.path stringByAppendingFormat:@",%@", date];
        }
        
        components.query = [NSString stringWithFormat:@"lang=%@", language];
        
        return [NSURLRequest requestWithURL:components.URL];
    }
    
    return nil;
}

+ (CZWeatherData *)transformResponse:(NSURLResponse *)response
                                data:(NSData *)data
                               error:(NSError *)error
                          forRequest:(CZWeatherRequest *)request
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode != 200) {
            return nil;
        }
    }
    
    if (data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        if (JSON) {
            CZWeatherData *weatherData = [[CZWeatherData alloc]_init];
            
            weatherData.placemark = [CZForecastioAPI placemarkForJSON:JSON];
            
            NSDictionary *currently = [JSON objectForKey:@"currently" class:[NSDictionary class]];
            if (currently) {
                weatherData.current = [CZForecastioAPI conditionForCurrently:currently];
            }
            
            NSDictionary *hourly = [JSON objectForKey:@"hourly" class:[NSDictionary class]];
            if (hourly) {
                weatherData.hourlyForecasts = [CZForecastioAPI conditionsForHourly:hourly];
            }
            
            NSDictionary *daily = [JSON objectForKey:@"daily" class:[NSDictionary class]];
            if (daily) {
                weatherData.dailyForecasts = [CZForecastioAPI conditionsForDaily:daily];
            }
            
            return weatherData;
        }
    }
    
    return nil;
}

+ (NSArray *)conditionsForDaily:(NSDictionary *)daily
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSArray *data = [daily objectForKey:@"data" class:[NSArray class]];
    if (data) {
        for (NSDictionary *day in data) {
            CZWeatherForecastCondition *condition = [[CZWeatherForecastCondition alloc]_init];
            
            condition.summary = day[@"summary"];
            condition.climacon = [CZForecastioAPI climaconForIconName:day[@"icon"]];
            condition.lowTemperature = [CZForecastioAPI temperatureForDataPoint:day name:@"temperatureMin"];
            condition.highTemperature = [CZForecastioAPI temperatureForDataPoint:day name:@"temperatureMax"];
            condition.humidity = [CZForecastioAPI humidityForDataPoint:day];
            condition.date = [CZForecastioAPI dateForDataPoint:day];
            
            [conditions addObject:condition];
        }
    }
    return conditions;
}

+ (NSArray *)conditionsForHourly:(NSDictionary *)hourly
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSArray *data = [hourly objectForKey:@"data" class:[NSArray class]];
    if (data) {
        for (NSDictionary *hour in data) {
            CZWeatherHourlyCondition *condition = [[CZWeatherHourlyCondition alloc]_init];
            
            condition.summary = hour[@"summary"];
            condition.climacon = [CZForecastioAPI climaconForIconName:hour[@"icon"]];
            condition.temperature = [CZForecastioAPI temperatureForDataPoint:hour name:@"temperature"];
            condition.windSpeed = [CZForecastioAPI windSpeedForDataPoint:hour];
            condition.windDirection = [CZForecastioAPI windDirectionForDataPoint:hour];
            condition.humidity = [CZForecastioAPI humidityForDataPoint:hour];
            condition.date = [CZForecastioAPI dateForDataPoint:hour];
            
            [conditions addObject:condition];
        }
    }
    return conditions;
}

+ (CZWeatherCurrentCondition *)conditionForCurrently:(NSDictionary *)currently
{
    CZWeatherCurrentCondition *condition = [[CZWeatherCurrentCondition alloc]_init];
    
    condition.summary = currently[@"summary"];
    condition.climacon = [CZForecastioAPI climaconForIconName:currently[@"icon"]];
    condition.temperature = [CZForecastioAPI temperatureForDataPoint:currently name:@"temperature"];
    condition.windSpeed = [CZForecastioAPI windSpeedForDataPoint:currently];
    condition.pressure = [CZForecastioAPI pressureForDataPoint:currently];
    condition.windDirection = [CZForecastioAPI windDirectionForDataPoint:currently];
    condition.humidity = [CZForecastioAPI humidityForDataPoint:currently];
    condition.date = [CZForecastioAPI dateForDataPoint:currently];
    
    return condition;
}

+ (CZTemperature)temperatureForDataPoint:(NSDictionary *)dataPoint name:(NSString *)name
{
    return (CZTemperature) {
        .f = dataPoint[name] ? [dataPoint[name]floatValue] : CZValueUnavailable,
        .c = dataPoint[name] ? cz_ftoc([dataPoint[name]floatValue]) : CZValueUnavailable
    };
}

+ (CZWindSpeed)windSpeedForDataPoint:(NSDictionary *)dataPoint
{
    return (CZWindSpeed) {
        .mph = dataPoint[@"windSpeed"] ? [dataPoint[@"windSpeed"]floatValue] : CZValueUnavailable,
        .kph = dataPoint[@"windSpeed"] ? cz_mtokph([dataPoint[@"windSpeed"]floatValue]) : CZValueUnavailable
    };
}

+ (CZPressure)pressureForDataPoint:(NSDictionary *)dataPoint
{
    return (CZPressure) {
        .mb = dataPoint[@"pressure"] ? [dataPoint[@"pressure"]floatValue] : CZValueUnavailable,
        .inch = dataPoint[@"pressure"] ? cz_mbtoin([dataPoint[@"pressure"]floatValue]) : CZValueUnavailable
    };
}

+ (CZWindDirection)windDirectionForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"windBearing"] ? [dataPoint[@"windBearing"]floatValue] : CZValueUnavailable;
}

+ (CZHumidity)humidityForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"humidity"] ? 100.0 * [dataPoint[@"humidity"]floatValue] : CZValueUnavailable;
}

+ (NSDate *)dateForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"time"] ? [NSDate dateWithTimeIntervalSince1970:[dataPoint[@"time"]floatValue]] : nil;
}

+ (Climacon)climaconForIconName:(NSString *)iconName
{
    if ([@[@"clear-day"] containsObject:iconName]) {
        return ClimaconSun;
    }
    
    if ([@[@"clear-night"] containsObject:iconName]) {
        return ClimaconMoon;
    }
    
    if ([@[@"rain"] containsObject:iconName]) {
        return ClimaconRain;
    }
    
    if ([@[@"snow"] containsObject:iconName]) {
        return ClimaconSnow;
    }
    
    if ([@[@"sleet"] containsObject:iconName]) {
        return ClimaconSleet;
    }
    
    if ([@[@"wind"] containsObject:iconName]) {
        return ClimaconWind;
    }
    
    if ([@[@"fog"] containsObject:iconName]) {
        return ClimaconFog;
    }
    
    if ([@[@"cloudy"] containsObject:iconName]) {
        return ClimaconCloud;
    }
    
    if ([@[@"partly-cloudy-day"] containsObject:iconName]) {
        return ClimaconCloudSun;
    }
    
    if ([@[@"partly-cloudy-night"] containsObject:iconName]) {
        return ClimaconCloudMoon;
    }
    
    return ClimaconUnknown;
}

+ (CLPlacemark *)placemarkForJSON:(NSDictionary *)JSON
{
#if TARGET_OS_IOS || TARGET_OS_OSX
    if (JSON) {
        CLLocationDegrees latitude = [JSON[@"latitude"]floatValue];
        CLLocationDegrees longitude = [JSON[@"longitude"]floatValue];
        return [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                    addressDictionary:nil];
    }
#endif
    return nil;
}

+ (NSString *)componentForLocation:(CZWeatherLocation *)location
{
    return [NSString stringWithFormat:@"%.4f,%.4f",
            location.coordinate.latitude,
            location.coordinate.longitude];
}

@end
