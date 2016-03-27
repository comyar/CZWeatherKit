//
//  CZWeatherKit+Internal.h
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

// -----
// @warning Not for external use.
// -----

#pragma mark - Imports

#if !(TARGET_OS_TV)
#import <AddressBook/AddressBook.h>
#endif

#import "CZWeatherKit.h"
#import "NSDictionary+Internal.h"
#import "CZWeatherData+Internal.h"
#import "CZWeatherService+Internal.h"
#import "CZWeatherRequest+Internal.h"
#import "CZWeatherLocation+Internal.h"
#import "CZForecastioRequest+Internal.h"
#import "CZWundergroundRequest+Internal.h"
#import "CZOpenWeatherMapRequest+Internal.h"
#import "CZWeatherHourlyCondition+Internal.h"
#import "CZWeatherCurrentCondition+Internal.h"
#import "CZWeatherForecastCondition+Internal.h"

#if TARGET_OS_IPHONE

#define kABZipKey (__bridge NSString *)kABPersonAddressZIPKey
#define kABCityKey (__bridge NSString *)kABPersonAddressCityKey
#define kABStateKey (__bridge NSString *)kABPersonAddressStateKey
#define kABCountryKey (__bridge NSString *)kABPersonAddressCountryKey
#define kABCountryCodeKey (__bridge NSString *)kABPersonAddressCountryCodeKey

#elif TARGET_OS_MAC

#define kABZipKey kABAddressZIPKey
#define kABCityKey kABAddressCityKey
#define kABStateKey kABAddressStateKey
#define kABCountryKey kABAddressCountryKey
#define kABCountryCodeKey kABAddressCountryCodeKey

#endif


#pragma mark - Functions

static inline float cz_ftoc(float f) {
    return (f - 32.0) * (5.0 / 9.0);
}

static inline float cz_ctof(float c) {
    return c * (9.0 / 5.0) + 32.0;
}

static inline float cz_ktoc(float k) {
    return k - 273.15;
}

static inline float cz_ktof(float k) {
    return cz_ctof(cz_ktoc(k));
}

static inline float cz_mtokph(float mph) {
    return 1.60934 * mph;
}

static inline float cz_mpstomph(float mps) {
    return 2.236936 * mps;
}

static inline float cz_mpstokph(float mps) {
    return 3.6 * mps;
}

static inline float cz_mbtoin(float mb) {
    return 0.0295301 * mb;
}

static inline float cz_intomb(float inch) {
    return 33.8637526 * inch;
}

// must end list with long min
static inline BOOL cz_match(long match, long against, ...) {
    va_list args;
    va_start(args, against);
    long read = LONG_MIN;
    while ((read = va_arg(args, long)) != LONG_MIN) {
        if (read == match) {
            va_end(args);
            return YES;
        }
    }
    va_end(args);
    return NO;
}

