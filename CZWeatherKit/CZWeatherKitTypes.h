//
//  CZWeatherKitTypes.h
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
 A structure that contains a temperature in both Fahrenheit and Celsius.
 */
typedef struct {
    
    /**
     The Fahrenheit representation of the temperature.
     */
    float f;
    
    /**
     The Celsius representation of the temperature.
     */
    float c;
} CZTemperature;

/**
 A structure that contains wind speed in both miles-per-hour and 
 kilometers-per-hour.
 */
typedef struct {
    
    /**
     The wind speed in miles-per-hour.
     */
    float mph;
    
    /**
     The wind speed in kilometers-per-hour.
     */
    float kph;
    
} CZWindSpeed;

/**
 A structure that contains air pressure in both millibars and inches.
 */
typedef struct {
    
    /**
     The pressure in millibars.
     */
    float mb;
    
    /**
     The pressure in inches.
     */
    float inch;
} CZPressure;

/**
 Represents air humidity as a percent.
 */
typedef float CZHumidity;

/**
 Represents wind direction in degrees.
 */
typedef float CZWindDirection;


#pragma mark - Macros

/**
 Represents an unavailable value. Use this macro to differentiate between a 
 missing value and zero.
 */
#ifndef CZValueUnavailable
#define CZValueUnavailable FLT_MIN
#endif


