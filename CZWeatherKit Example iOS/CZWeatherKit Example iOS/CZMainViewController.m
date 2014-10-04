//
//  CZMainViewController.m
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

#import "CZMainViewController.h"
#import "CZWeatherView.h"


#pragma mark - CZMainViewController Class Extension

@interface CZMainViewController ()

// YES if the view has appeared
@property (nonatomic) BOOL              hasAppeared;

// View to display weather information
@property (nonatomic) CZWeatherView     *weatherView;

@end


#pragma mark - CZMainViewController Implementation

@implementation CZMainViewController

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.439 green:0.868 blue:0.999 alpha:1.000];
    self.weatherView = [[CZWeatherView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.weatherView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.hasAppeared) {
        [self updateWeather];
        self.hasAppeared = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark Updating Weather Data

- (void)updateWeather
{
    [self.weatherView.activityIndicator startAnimating];
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.service = [CZOpenWeatherMapService new];
    request.location = [CZWeatherLocation locationWithCity:@"Austin" state:@"TX"];
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            __block CZWeatherCondition *condition = (CZWeatherCondition *)data;
            CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
            request.service = [CZOpenWeatherMapService new];
            request.location = [CZWeatherLocation locationWithCity:@"Austin" state:@"TX"];
            [request performRequestWithHandler:^(id data, NSError *error) {
                if (data) {
                    self.weatherView.locationLabel.text = @"Austin, TX";
                    
                    // Current Conditions
                    self.weatherView.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.0f°", condition.temperature.f];
                    self.weatherView.hiloTemperatureLabel.text = [NSString stringWithFormat:@"H %.0f  L %.0f", condition.highTemperature.f,
                                                                  condition.lowTemperature.f];
                    self.weatherView.conditionIconLabel.text = [NSString stringWithFormat:@"%c", condition.climaconCharacter];
                    self.weatherView.conditionDescriptionLabel.text = [condition.summary capitalizedString];
                    
                    // Forecast
                    NSArray *forecasts = (NSArray *)data;
                    if ([forecasts count] >= 3) {
                        NSDateFormatter *dateFormatter = [NSDateFormatter new];
                        dateFormatter.dateFormat = @"EEE";
                        
                        NSString *iconOne = [NSString stringWithFormat:@"%c", ((CZWeatherCondition *)forecasts[0]).climaconCharacter];
                        self.weatherView.forecastDayOneLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
                        self.weatherView.forecastIconOneLabel.text = iconOne;
                        
                        
                        NSString *iconTwo = [NSString stringWithFormat:@"%c", ((CZWeatherCondition *)forecasts[1]).climaconCharacter];
                        self.weatherView.forecastDayTwoLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:172800]];
                        self.weatherView.forecastIconTwoLabel.text = iconTwo;
                        
                        
                        NSString *iconThree = [NSString stringWithFormat:@"%c", ((CZWeatherCondition *)forecasts[2]).climaconCharacter];
                        self.weatherView.forecastDayThreeLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:259200]];
                        self.weatherView.forecastIconThreeLabel.text = iconThree;
                    }
                    
                    // Updated
                    NSString *updated = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                       dateStyle:NSDateFormatterMediumStyle
                                                                       timeStyle:NSDateFormatterShortStyle];
                    self.weatherView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updated];
                }
                [self.weatherView.activityIndicator stopAnimating];
            }];
        } else {
            [self.weatherView.activityIndicator stopAnimating];
        }
    }];
}



@end
