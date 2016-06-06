//
//  CZOpenWeatherMapAPI.m
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

#import "CZOpenWeatherMapAPI.h"
#import "CZOpenWeatherMapRequest.h"
#import "CZWeatherKitInternal.h"


#pragma mark - CZOpenWeatherMapAPI Implementation

@implementation CZOpenWeatherMapAPI

+ (NSString *)cacheKeyForRequest:(CZWeatherRequest *)request
{
    return [CZOpenWeatherMapAPI transformRequest:request].URL.absoluteString;
}

+ (NSURLRequest *)transformRequest:(CZWeatherRequest *)request
{
    if ([request isKindOfClass:[CZOpenWeatherMapRequest class]]) {
        CZOpenWeatherMapRequest *openWeatherMapRequest = (CZOpenWeatherMapRequest *)request;
        
        NSURLComponents *components = [NSURLComponents new];
        components.scheme = @"http";
        components.host = [openWeatherMapRequest.feature isEqualToString:@"history/city"] ? @"openweathermap.org" : @"api.openweathermap.org";
        components.path = [NSString stringWithFormat:@"/data/2.5/%@", openWeatherMapRequest.feature];
        components.query = [CZOpenWeatherMapAPI queryForRequest:openWeatherMapRequest];
        
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
            CZOpenWeatherMapRequest *openWeatherMapRequest = (CZOpenWeatherMapRequest *)request;
            CZWeatherData *weatherData = [[CZWeatherData alloc]_init];
            
#if TARGET_OS_IOS || TARGET_OS_OSX
            weatherData.placemark = [CZOpenWeatherMapAPI placemarkForJSON:JSON];
#endif
            
            if ([openWeatherMapRequest.feature isEqualToString:@"weather"]) {
                weatherData.current = [CZOpenWeatherMapAPI conditionForCurrentJSON:JSON];
            }
            
            if ([openWeatherMapRequest.feature isEqualToString:@"forecast/daily"]) {
                weatherData.dailyForecasts = [CZOpenWeatherMapAPI conditionsForDailyForecastJSON:JSON];
            }
            
            if ([openWeatherMapRequest.feature isEqualToString:@"forecast/hourly"]) {
                weatherData.hourlyForecasts = [CZOpenWeatherMapAPI conditionsForHourlyForecastJSON:JSON];
            }
            
            if ([openWeatherMapRequest.feature isEqualToString:@"history/city"]) {
                weatherData.hourlyForecasts = [CZOpenWeatherMapAPI conditionsForHourlyForecastJSON:JSON];
            }
            
            return weatherData;
        }
    }
    
    return nil;
}

+ (NSArray *)conditionsForHourlyForecastJSON:(NSDictionary *)JSON
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSArray *list = [JSON objectForKey:@"list" class:[NSArray class]];
    for (NSDictionary *hour in list) {
        CZWeatherHourlyCondition *condition = [[CZWeatherHourlyCondition alloc]_init];
        
        NSDictionary *main = [hour objectForKey:@"main" class:[NSDictionary class]];
        NSArray *weather = [hour objectForKey:@"weather" class:[NSArray class]];
        NSDictionary *wind = [hour objectForKey:@"wind" class:[NSDictionary class]];
        
        if ([weather count] > 0) {
            NSDictionary *inner = [weather[0] isKindOfClass:[NSDictionary class]] ? weather[0] : nil;
            if (inner) {
                condition.summary = inner[@"main"];
                condition.climacon =[CZOpenWeatherMapAPI climaconForIcon:inner[@"icon"]];
            }
        }
        
        condition.date = [CZOpenWeatherMapAPI dateForDataPoint:hour];
        condition.humidity = [CZOpenWeatherMapAPI humidityForDataPoint:hour];
        condition.windSpeed = [CZOpenWeatherMapAPI windSpeedForDataPoint:wind];
        condition.windDirection = [CZOpenWeatherMapAPI windDirectionForDataPoint:wind];
        condition.humidity = [CZOpenWeatherMapAPI humidityForDataPoint:main];
        condition.temperature = [CZOpenWeatherMapAPI temperatureForDataPoint:main name:@"temp"];
        
        [conditions addObject:condition];
    }
    return conditions;
}

+ (NSArray *)conditionsForDailyForecastJSON:(NSDictionary *)JSON
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSArray *list = [JSON objectForKey:@"list" class:[NSArray class]];
    for (NSDictionary *day in list) {
        CZWeatherForecastCondition *condition = [[CZWeatherForecastCondition alloc]_init];
        
        NSArray *weather = [day objectForKey:@"weather" class:[NSArray class]];
        if ([weather count] > 0) {
            
            NSDictionary *inner = [weather[0] isKindOfClass:[NSDictionary class]] ? weather[0] : nil;
            if (inner) {
                condition.summary = inner[@"main"];
                condition.climacon =[CZOpenWeatherMapAPI climaconForIcon:inner[@"icon"]];
            }
        }
        
        condition.date = [CZOpenWeatherMapAPI dateForDataPoint:day];
        condition.humidity = [CZOpenWeatherMapAPI humidityForDataPoint:day];
        if ([day objectForKey:@"temp" class:[NSDictionary class]]) {
            condition.lowTemperature = [CZOpenWeatherMapAPI temperatureForDataPoint:day[@"temp"] name:@"min"];
            condition.highTemperature = [CZOpenWeatherMapAPI temperatureForDataPoint:day[@"temp"] name:@"max"];
        }
        
        [conditions addObject:condition];
    }
    return conditions;
}

+ (CZWeatherCurrentCondition *)conditionForCurrentJSON:(NSDictionary *)JSON
{
    CZWeatherCurrentCondition *condition = [[CZWeatherCurrentCondition alloc]_init];
    NSDictionary *main = [JSON objectForKey:@"main" class:[NSDictionary class]];
    NSDictionary *wind = [JSON objectForKey:@"wind" class:[NSDictionary class]];
    NSArray *weather = [JSON objectForKey:@"weather" class:[NSArray class]];
    
    if ([weather count] > 0) {
        NSDictionary *day = [weather[0] isKindOfClass:[NSDictionary class]] ? weather[0] : nil;
        if (day) {
            condition.summary = day[@"main"];
            condition.climacon =[CZOpenWeatherMapAPI climaconForIcon:day[@"icon"]];
        }
    }
    
    condition.date = [CZOpenWeatherMapAPI dateForDataPoint:JSON];
    condition.temperature = [CZOpenWeatherMapAPI temperatureForDataPoint:main name:@"temp"];
    condition.lowTemperature = [CZOpenWeatherMapAPI temperatureForDataPoint:main name:@"temp_min"];
    condition.highTemperature = [CZOpenWeatherMapAPI temperatureForDataPoint:main name:@"temp_max"];
    condition.windSpeed = [CZOpenWeatherMapAPI windSpeedForDataPoint:wind];
    condition.windDirection = [CZOpenWeatherMapAPI windDirectionForDataPoint:wind];
    condition.pressure = [CZOpenWeatherMapAPI pressureForDataPoint:main];
    condition.humidity = [CZOpenWeatherMapAPI humidityForDataPoint:main];
    
    return condition;
}


+ (CZTemperature)temperatureForDataPoint:(NSDictionary *)dataPoint name:(NSString *)name
{
    return (CZTemperature) {
        .f = dataPoint[name] ? cz_ktof([dataPoint[name]floatValue]) : CZValueUnavailable,
        .c = dataPoint[name] ? cz_ktoc([dataPoint[name]floatValue]) : CZValueUnavailable
    };
}

+ (CZWindSpeed)windSpeedForDataPoint:(NSDictionary *)dataPoint
{
    return (CZWindSpeed) {
        .mph = dataPoint[@"speed"] ? cz_mpstomph([dataPoint[@"speed"]floatValue]) : CZValueUnavailable,
        .kph = dataPoint[@"speed"] ? cz_mpstokph([dataPoint[@"speed"]floatValue]) : CZValueUnavailable
    };
}

+ (CZPressure)pressureForDataPoint:(NSDictionary *)dataPoint
{
    return (CZPressure) {
        .mb = dataPoint[@"pressure"] ? [dataPoint[@"pressure"]floatValue] : CZValueUnavailable,
        .inch = dataPoint[@"pressure"] ? cz_mbtoin([dataPoint[@"pressure"]floatValue]) : CZValueUnavailable,
    };
}

+ (CZWindDirection)windDirectionForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"deg"] ? [dataPoint[@"deg"]floatValue] : CZValueUnavailable;
}

+ (CZHumidity)humidityForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"humidity"] ? [dataPoint[@"humidity"]floatValue] : CZValueUnavailable;
}

+ (NSDate *)dateForDataPoint:(NSDictionary *)dataPoint
{
    return dataPoint[@"dt"] ? [NSDate dateWithTimeIntervalSince1970:[dataPoint[@"dt"]floatValue]] : nil;
}

+ (Climacon)climaconForIcon:(NSString *)icon
{
    if ([@[@"01d"] containsObject:icon]) {
        return ClimaconSun;
    }
    
    if ([@[@"01n"] containsObject:icon]) {
        return ClimaconMoon;
    }
    
    if ([@[@"02d"] containsObject:icon]) {
        return ClimaconCloudSun;
    }
    
    if ([@[@"02n"] containsObject:icon]) {
        return ClimaconCloudMoon;
    }
    
    if ([@[@"03d", @"03n", @"04d", @"04n"] containsObject:icon]) {
        return ClimaconCloud;
    }
    
    if ([@[@"09d", @"09n"] containsObject:icon]) {
        return ClimaconShowers;
    }
    
    if ([@[@"10d"] containsObject:icon]) {
        return ClimaconRainSun;
    }
    
    if ([@[@"10n"] containsObject:icon]) {
        return ClimaconRainMoon;
    }
    
    if ([@[@"11d", @"11n"] containsObject:icon]) {
        return ClimaconLightning;
    }
    
    if ([@[@"13d", @"13n"] containsObject:icon]) {
        return ClimaconSnow;
    }
    
    if ([@[@"50d", @"50n"] containsObject:icon]) {
        return ClimaconHaze;
    }
    
    return ClimaconUnknown;
}

#if TARGET_OS_IOS || TARGET_OS_OSX
+ (CLPlacemark *)placemarkForJSON:(NSDictionary *)JSON
{
    if (JSON) {
        NSDictionary *city = [JSON objectForKey:@"city" class:[NSDictionary class]];
        NSDictionary *sys = [JSON objectForKey:@"sys" class:[NSDictionary class]];
        NSDictionary *coord = [JSON objectForKey:@"coord" class:[NSDictionary class]];
        
        NSMutableDictionary *addressDictionary = [NSMutableDictionary new];
        if (sys[@"country"]) {
            addressDictionary[kABCountryKey] = sys[@"country"];
            addressDictionary[kABCountryCodeKey] = sys[@"country"];
        } else if (city[@"country"]) {
            addressDictionary[kABCountryKey] = city[@"country"];
            addressDictionary[kABCountryCodeKey] = city[@"country"];
        }
        
        if (JSON[@"name"]) {
            addressDictionary[kABCityKey] = JSON[@"name"];
        } else if (city[@"name"]) {
            addressDictionary[kABCityKey] = city[@"name"];
        }
        
        CLLocationDegrees latitude = CZValueUnavailable;
        CLLocationDegrees longitude = CZValueUnavailable;
        
        if (coord) {
            latitude = [coord[@"lat"]floatValue];
            longitude = [coord[@"lon"]floatValue];
        } else if ([city objectForKey:@"coord" class:[NSDictionary class]]) {
            latitude = [city[@"coord"][@"lat"]floatValue];
            longitude = [city[@"coord"][@"lon"]floatValue];
        }
        
        if (![addressDictionary count] && latitude == CZValueUnavailable && longitude == CZValueUnavailable) {
            return nil;
        }
        
        return [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                    addressDictionary:addressDictionary];
    }
    return nil;
}
#endif

+ (NSString *)queryForRequest:(CZOpenWeatherMapRequest *)request
{
    NSString *location = [CZOpenWeatherMapAPI componentForLocation:request.location];
    NSString *language = request.language ? request.language : @"en";
    
    NSString *query = [NSString stringWithFormat:@"%@&lang=%@&mode=json", location, language];
    if ([request.feature isEqualToString:@"forecast/daily"]) {
        query = [query stringByAppendingFormat:@"&cnt=%ld", (long)request.days];
    } else if ([request.feature isEqualToString:@"history/city"]) {
        query = [query stringByAppendingFormat:@"&type=hourly&start=%ld&end=%ld",
                 (long)[request.start timeIntervalSince1970], (long)[request.end timeIntervalSince1970]];
    }
    
    if ([request.key length]) {
        query = [query stringByAppendingFormat:@"&APPID=%@", request.key];
    }
    
    return query;
}

+ (NSString *)componentForLocation:(CZWeatherLocation *)location
{
    if (location.state) {
        return [NSString stringWithFormat:@"q=%@,US", location.city];
    } else if (location.country) {
        return [NSString stringWithFormat:@"q=%@,%@",
                [self urlEncode:location.city],
                [self urlEncode:location.country]];
    }
    return [NSString stringWithFormat:@"lat=%.4f&lon=%.4f",
            location.coordinate.latitude, location.coordinate.longitude];
}

+ (NSString *)urlEncode:(NSString *)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
