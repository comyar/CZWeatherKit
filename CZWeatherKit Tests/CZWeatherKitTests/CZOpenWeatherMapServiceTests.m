//
//  CZOpenWeatherMapServiceTests.m
//  CZWeatherKit Tests
//
//  Created by Comyar Zaheri on 5/24/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//

#import "CZWeatherServiceTestCase.h"
#import "CZOpenWeatherMapService.h"

#pragma mark - CZOpenWeatherMapServiceTests Interface

@interface CZOpenWeatherMapServiceTests : CZWeatherServiceTestCase

@end


#pragma mark - CZOpenWeatherMapServiceTests Implementation

@implementation CZOpenWeatherMapServiceTests

- (void)setUp
{
    self.service = [CZOpenWeatherMapService serviceWithKey:[self loadFile:@"" extension:@"txt"]];
}

- (NSString *)loadFile:(NSString *)filename extension:(NSString *)extension
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
