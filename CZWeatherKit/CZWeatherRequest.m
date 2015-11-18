//
//  CZWeatherDataRequest.m
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

#import "CZWeatherRequest.h"
#import "CZWeatherLocation.h"
#import "CZWeatherKitInternal.h"
#import "CZWeatherAPI.h"


#pragma mark - CZWeatherDataRequest Class Extension

@interface CZWeatherRequest ()

@property (NS_NONATOMIC_IOSONLY) NSURLSession *session;

@end


#pragma mark - CZWeatherRequest Implementation

@implementation CZWeatherRequest

- (instancetype)_init
{
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot use abstract class CZWeatherDataRequest."
                                 userInfo:nil];

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot use abstract class CZWeatherDataRequest."
                                 userInfo:nil];
}

#pragma mark NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark Using a Weather Data Request

- (void)sendWithCompletion:(CZWeatherRequestCompletion)completion
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot use abstract class CZWeatherDataRequest."
                                 userInfo:nil];
}

- (void)dispatchWithAPI:(id<CZWeatherAPI>)API
             completion:(CZWeatherRequestCompletion)completion
{
    if (!completion) {
        return;
    } else if (!API) {
        completion(nil, nil);
        return;
    }
    
    CZWeatherRequest *copy = [self copy];
    NSURLRequest *request = [API transformRequest:copy];
    if (!request) {
        completion(nil, nil);
        return;
    }
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CZWeatherData *result = [API transformResponse:response data:data error:error forRequest:copy];
        completion(result, error);
    }]resume];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot use abstract class CZWeatherDataRequest."
                                 userInfo:nil];
}

#pragma mark Internal

- (Class)API
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot use abstract class CZWeatherDataRequest."
                                 userInfo:nil];
}

@end
