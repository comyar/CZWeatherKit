//
//  Climacons.h
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

@import Foundation;


#pragma mark - Type Definitions

/**
 Contains the mappings from icon to character for the Climacons font, bundled by 
 Christian Naths.
 http://adamwhitcroft.com/climacons/font/ 
 https://github.com/christiannaths/Climacons-Font
 
 Climacons first created in icon form by Adam Whitcroft.
 http://adamwhitcroft.com/climacons/
 */
typedef NS_ENUM(char, Climacon) {
    ClimaconUnknown                 = '~',
    
    ClimaconCloud                   = '!',
    ClimaconCloudSun                = '"',
    ClimaconCloudMoon               = '#',
    
    ClimaconRain                    = '$',
    ClimaconRainSun                 = '%',
    ClimaconRainMoon                = '&',
    
    ClimaconShowers                 = '\'',
    ClimaconShowersSun              = '(',
    ClimaconShowersMoon             = ')',
    
    ClimaconDownpour                = '*',
    ClimaconDownpourSun             = '+',
    ClimaconDownpourMoon            = ',',
    
    ClimaconDrizzle                 = '-',
    ClimaconDrizzleSun              = '.',
    ClimaconDrizzleMoon             = '/',
    
    ClimaconSleet                   = '0',
    ClimaconSleetSun                = '1',
    ClimaconSleetMoon               = '2',
    
    ClimaconHail                    = '3',
    ClimaconHailSun                 = '4',
    ClimaconHailMoon                = '5',
    
    ClimaconFlurries                = '6',
    ClimaconFlurriesSun             = '7',
    ClimaconFlurriesMoon            = '8',
    
    ClimaconSnow                    = '9',
    ClimaconSnowSun                 = ':',
    ClimaconSnowMoon                = ';',
    
    ClimaconFog                     = '<',
    ClimaconFogSun                  = '=',
    ClimaconFogMoon                 = '>',
    
    ClimaconHaze                    = '?',
    ClimaconHazeSun                 = '@',
    ClimaconHazeMoon                = 'A',
    
    ClimaconWind                    = 'B',
    ClimaconWindCloud               = 'C',
    ClimaconWindCloudSun            = 'D',
    ClimaconWindCloudMoon           = 'E',
    
    ClimaconLightning               = 'F',
    ClimaconLightningSun            = 'G',
    ClimaconLightningMoon           = 'H',
    
    ClimaconSun                     = 'I',
    ClimaconSunset                  = 'J',
    ClimaconSunrise                 = 'K',
    ClimaconSunLow                  = 'L',
    ClimaconSunLower                = 'M',
    
    ClimaconMoon                    = 'N',
    ClimaconMoonNew                 = 'O',
    ClimaconMoonWaxingCrescent      = 'P',
    ClimaconMoonWaxingQuarter       = 'Q',
    ClimaconMoonWaxingGibbous       = 'R',
    ClimaconMoonFull                = 'S',
    ClimaconMoonWaningGibbous       = 'T',
    ClimaconMoonWaningQuarter       = 'U',
    ClimaconMoonWaningCrescent      = 'V',
    
    ClimaconSnowflake               = 'W',
    ClimaconTornado                 = 'X',
    
    ClimaconThermometer             = 'Y',
    ClimaconThermometerLow          = 'Z',
    ClimaconThermometerMediumLow    = '[',
    ClimaconThermometerMediumHigh   = '\\',
    ClimaconThermometerHigh         = ']',
    ClimaconThermometerFull         = '^',
    ClimaconCelsius                 = '_',
    ClimaconFahrenheit              = '`',
    ClimaconCompass                 = 'a',
    ClimaconCompassNorth            = 'b',
    ClimaconCompassEast             = 'c',
    ClimaconCompassSouth            = 'd',
    ClimaconCompassWest             = 'e',
    
    ClimaconUmbrella                = 'f',
    ClimaconSunglasses              = 'g',
    
    ClimaconCloudRefresh            = 'h',
    ClimaconCloudUp                 = 'i',
    ClimaconCloudDown               = 'j'
};


#pragma mark - Constants

/**
 The name of the Climacons font.
 */
static NSString * const CZClimaconsFontName = @"Climacons-Font";
