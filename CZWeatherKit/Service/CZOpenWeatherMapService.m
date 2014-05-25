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
    return nil;
}

- (CZWeatherData *)weatherDataForResponseData:(NSData *)data request:(CZWeatherRequest *)request
{
    return nil;
}

@end
