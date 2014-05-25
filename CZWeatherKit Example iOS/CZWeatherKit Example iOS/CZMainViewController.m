//
//  CZViewController.m
//  CZWeatherKit Example iOS
//
//  Created by Comyar Zaheri on 5/25/14.
//  Copyright (c) 2014 Comyar Zaheri. All rights reserved.
//


#pragma mark - Imports

#import "CZMainViewController.h"
#import "CZWeatherView.h"

@interface CZMainViewController ()

@property (nonatomic) BOOL              hasAppeared;

@property (nonatomic) CZWeatherView     *weatherView;

@end

@implementation CZMainViewController

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

- (void)updateWeather
{
    [self.weatherView.activityIndicator startAnimating];
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.service = [CZOpenWeatherMapService new];
    request.location[CZWeatherKitLocationName.StateCityName] = @"Austin,TX";
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            __block CZWeatherCondition *condition = (CZWeatherCondition *)data;
            CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
            request.service = [CZOpenWeatherMapService new];
            request.location[CZWeatherKitLocationName.StateCityName] = @"Austin,TX";
            [request performRequestWithHandler:^(id data, NSError *error) {
                if (data) {
                    self.weatherView.locationLabel.text = request.location[CZWeatherKitLocationName.StateCityName];
                    
                    // Current Conditions
                    self.weatherView.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.0f°", condition.temperature.f];
                    self.weatherView.hiloTemperatureLabel.text = [NSString stringWithFormat:@"H %.0f  L %.0f", condition.highTemperature.f,
                                                                  condition.lowTemperature.f];
                    self.weatherView.conditionIconLabel.text = [NSString stringWithFormat:@"%c", condition.climaconCharacter];
                    self.weatherView.conditionDescriptionLabel.text = [condition.description capitalizedString];
                    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
