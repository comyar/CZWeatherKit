//
//  CZWundergroundAPI.m
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

#import "CZWundergroundAPI.h"
#import "CZWeatherKitInternal.h"


#pragma mark - CZWundergroundAPI Implementation

@implementation CZWundergroundAPI

+ (NSString *)cacheKeyForRequest:(CZWeatherRequest *)request
{
    return [CZWundergroundAPI transformRequest:request].URL.absoluteString;
}

+ (NSURLRequest *)transformRequest:(CZWeatherRequest *)request
{
    if ([request isKindOfClass:[CZWundergroundRequest class]]) {
        CZWundergroundRequest *wundergroundRequest = (CZWundergroundRequest *)request;
        NSString *language = wundergroundRequest.language ? wundergroundRequest.language : @"EN";
        NSString *location = [CZWundergroundAPI componentForLocation:request.location];
        
        NSURLComponents *components = [NSURLComponents new];
        components.scheme = @"http";
        components.host = @"api.wunderground.com";
        components.path = [NSString stringWithFormat:@"/api/%@/geolookup/%@/lang:%@/q/%@.json",
                           request.key, wundergroundRequest.feature, language, location];
        
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
            NSDictionary *resp = [JSON objectForKey:@"response"
                                             class:[NSDictionary class]];
            if (resp[@"error"]) {
                return nil;
            }
            
            CZWeatherData *weatherData = [[CZWeatherData alloc]_init];
            
            NSDictionary *features = [resp objectForKey:@"features"
                                                  class:[NSDictionary class]];
            
#if TARGET_OS_IOS || TARGET_OS_OSX
            if (features[@"geolookup"]) {
                NSDictionary *location = [JSON objectForKey:@"location" class:[NSDictionary class]];
                weatherData.placemark = [CZWundergroundAPI placemarkForLocation:location];
            }
#endif
            
            if (features[@"conditions"]) {
                NSDictionary *currentObservation = [JSON objectForKey:@"current_observation" class:[NSDictionary class]];
                weatherData.current = [CZWundergroundAPI conditionForCurrentObservation:currentObservation];
            }
            
            if (features[@"forecast"] || features[@"forecast10day"]) {
                NSDictionary *forecast = [JSON objectForKey:@"forecast" class:[NSDictionary class]];
                weatherData.dailyForecasts = [CZWundergroundAPI conditionsForForecast:forecast];
            }
            
            if (features[@"hourly"] || features[@"hourly10day"]) {
                NSArray *hourlyForecast = [JSON objectForKey:@"hourly_forecast" class:[NSArray class]];
                weatherData.hourlyForecasts = [CZWundergroundAPI conditionsForHourlyForecast:hourlyForecast];
            }
            
            if (features[@"history"]) {
                NSDictionary *history = [JSON objectForKey:@"history" class:[NSDictionary class]];
                weatherData.hourlyForecasts = [CZWundergroundAPI conditionsForHistory:history];
            }
            
            return weatherData;
        }
    }
    
    return nil;
}

+ (Climacon)climaconForIconName:(NSString *)iconName
{
    if ([@[@"chanceflurries", @"flurries"] containsObject:iconName]) {
        return ClimaconFlurries;
    }
    
    if ([@[@"chancerain", @"rain"] containsObject:iconName]) {
        return ClimaconRain;
    }
    
    if ([@[@"chancesleet", @"sleet"] containsObject:iconName]) {
        return ClimaconSleet;
    }
    
    if ([@[@"chancesnow", @"snow"] containsObject:iconName]) {
        return ClimaconSnow;
    }
    
    if ([@[@"chancetstorms", @"tstorms"] containsObject:iconName]) {
        return ClimaconLightning;
    }
    
    if ([@[@"clear", @"sunny"] containsObject:iconName]) {
        return ClimaconSun;
    }
    
    if ([@[@"cloudy"] containsObject:iconName]) {
        return ClimaconCloud;
    }
    
    if ([@[@"fog"] containsObject:iconName]) {
        return ClimaconFog;
    }
    
    if ([@[@"hazy"] containsObject:iconName]) {
        return ClimaconHaze;
    }
    
    if ([@[@"mostlycloudy"] containsObject:iconName]) {
        return ClimaconCloud;
    }
    
    if ([@[@"partlycloudy", @"partlysunny"] containsObject:iconName]) {
        return ClimaconCloudSun;
    }
    
    return ClimaconUnknown;
}

static NSDateFormatter *historyDateFormatter = nil;
+ (NSArray *)conditionsForHistory:(NSDictionary *)history
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSDictionary *observations = history[@"observations"];
    if (!historyDateFormatter) {
        historyDateFormatter = [NSDateFormatter new];
        historyDateFormatter.dateFormat = @"h:mm a z 'on' MMMM dd, yyyy";
        historyDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    for (NSDictionary *hour in observations) {
        CZWeatherHourlyCondition *condition = [[CZWeatherHourlyCondition alloc]_init];
        NSDictionary *date = [hour objectForKey:@"date" class:[NSDictionary class]];
        
        condition.summary = hour[@"conds"];
        condition.climacon = [CZWundergroundAPI climaconForIconName:hour[@"icon"]];
        condition.date = date[@"pretty"] ? [historyDateFormatter dateFromString:date[@"pretty"]] : nil;
        condition.temperature = (CZTemperature) {
            .f = [CZWundergroundAPI value:hour name:@"tempi"],
            .c = [CZWundergroundAPI value:hour name:@"tempm"]
        };
        condition.humidity = [CZWundergroundAPI value:hour name:@"hum"];
        condition.windDirection = [CZWundergroundAPI value:hour name:@"wdird"];
        condition.windSpeed = (CZWindSpeed) {
            .mph = [CZWundergroundAPI value:hour name:@"wspdi"],
            .kph = [CZWundergroundAPI value:hour name:@"wspdm"]
        };
        
        [conditions addObject:condition];
    }
    
    return conditions;
}

+ (NSArray *)conditionsForHourlyForecast:(NSArray *)hourlyForecast
{
    NSMutableArray *conditions = [NSMutableArray new];
    for (NSDictionary *hour in hourlyForecast) {
        CZWeatherHourlyCondition *condition = [[CZWeatherHourlyCondition alloc]_init];
        NSDictionary *fcttime = [hour objectForKey:@"FCTTIME" class:[NSDictionary class]];
        
        condition.climacon = [CZWundergroundAPI climaconForIconName:hour[@"icon"]];
        condition.summary = hour[@"condition"];
        condition.date = fcttime[@"epoch"] ? [NSDate dateWithTimeIntervalSince1970:[fcttime[@"epoch"]floatValue]] : nil;
        condition.temperature = (CZTemperature){
            .f = hour[@"temp"] ? [hour[@"temp"][@"english"]floatValue] : CZValueUnavailable,
            .c = hour[@"temp"] ? [hour[@"temp"][@"metric"]floatValue] : CZValueUnavailable
        };
        condition.windDirection = hour[@"wdir"] ? [hour[@"wdir"][@"degrees"]floatValue] : CZValueUnavailable;
        condition.humidity = [CZWundergroundAPI value:hour name:@"humidity"];
        condition.windSpeed = (CZWindSpeed){
            .mph = hour[@"wspd"] ? [hour[@"wspd"][@"english"]floatValue] : CZValueUnavailable,
            .kph = hour[@"wspd"] ? [hour[@"wspd"][@"metric"]floatValue] : CZValueUnavailable
        };
        
        [conditions addObject:condition];
    }
    return conditions;
}

+ (NSArray *)conditionsForForecast:(NSDictionary *)forecast
{
    NSMutableArray *conditions = [NSMutableArray new];
    NSDictionary *simpleForecast = [forecast objectForKey:@"simpleforecast" class:[NSDictionary class]];
    NSArray *forecastDay = [simpleForecast objectForKey:@"forecastday" class:[NSArray class]];
    for (NSDictionary *day in forecastDay) {
        CZWeatherForecastCondition *condition = [[CZWeatherForecastCondition alloc]_init];
        
        NSDictionary *date = [day objectForKey:@"date" class:[NSDictionary class]];
        
        condition.climacon = [CZWundergroundAPI climaconForIconName:day[@"icon"]];
        condition.summary = day[@"conditions"];
        condition.date = date[@"epoch"] ? [NSDate dateWithTimeIntervalSince1970:[date[@"epoch"]floatValue]] : nil;
        condition.lowTemperature = (CZTemperature){
            .f = day[@"low"] ? [day[@"low"][@"fahrenheit"]floatValue] : CZValueUnavailable,
            .c = day[@"low"] ? [day[@"low"][@"celsius"]floatValue] : CZValueUnavailable
        };
        condition.highTemperature = (CZTemperature){
            .f = day[@"high"] ? [day[@"high"][@"fahrenheit"]floatValue] : CZValueUnavailable,
            .c = day[@"high"] ? [day[@"high"][@"celsius"]floatValue] : CZValueUnavailable
        };
        condition.humidity = [CZWundergroundAPI value:day name:@"avehumidity"];
        
        [conditions addObject:condition];
    }
    return conditions;
}

+ (CZWeatherCurrentCondition *)conditionForCurrentObservation:(NSDictionary *)currentObservation
{
    CZWeatherCurrentCondition *condition = [[CZWeatherCurrentCondition alloc]_init];
    
    condition.climacon = [CZWundergroundAPI climaconForIconName:currentObservation[@"icon"]];
    condition.summary = currentObservation[@"weather"];
    condition.temperature = (CZTemperature){
        .f = [CZWundergroundAPI value:currentObservation name:@"temp_f"],
        .c = [CZWundergroundAPI value:currentObservation name:@"temp_c"]
    };
    condition.windSpeed = (CZWindSpeed){
        .mph = [CZWundergroundAPI value:currentObservation name:@"wind_mph"],
        .kph = [CZWundergroundAPI value:currentObservation name:@"wind_kph"]
    };
    condition.pressure = (CZPressure){
        .mb = [CZWundergroundAPI value:currentObservation name:@"pressure_mb"],
        .inch = [CZWundergroundAPI value:currentObservation name:@"pressure_in"]
    };
    condition.windDirection = [CZWundergroundAPI value:currentObservation name:@"wind_degrees"];
    condition.humidity = currentObservation[@"relative_humidity"] ?
        [[currentObservation[@"relative_humidity"] stringByReplacingOccurrencesOfString:@"%" withString:@""]floatValue] : CZValueUnavailable;

    condition.date = currentObservation[@"observation_epoch"] ?
        [NSDate dateWithTimeIntervalSince1970:[currentObservation[@"observation_epoch"]floatValue]] : nil;
    
    return condition;
}

+ (float)value:(NSDictionary *)dictionary name:(NSString *)name
{
    return dictionary[name] ? [dictionary[name]floatValue] : CZValueUnavailable;
}

#if TARGET_OS_IOS || TARGET_OS_OSX
+ (CLPlacemark *)placemarkForLocation:(NSDictionary *)location
{
    if (location) {
        NSDictionary *addressDictionary = @{ kABZipKey : location[@"zip"],
                                             kABCityKey :  location[@"city"],
                                             kABStateKey : location[@"state"],
                                             kABCountryKey : location[@"country"],
                                             kABCountryCodeKey : location[@"country_iso3166"]};
        CLLocationDegrees latitude = [location[@"lat"]floatValue];
        CLLocationDegrees longitude = [location[@"lon"]floatValue];
        return [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                    addressDictionary:addressDictionary];
    }
    return nil;
}
#endif

+ (NSString *)componentForLocation:(CZWeatherLocation *)location
{
    NSString *city = [location.city stringByReplacingOccurrencesOfString:@" "
                                                              withString:@"_"];
    if (location.state) {
        return [NSString stringWithFormat:@"%@/%@", location.state, city];
    } else if (location.country) {
        return [NSString stringWithFormat:@"%@/%@", location.country, city];
    }
    
    return [NSString stringWithFormat:@"%.4f,%.4f", location.coordinate.latitude,
                                                    location.coordinate.longitude];
}

@end
