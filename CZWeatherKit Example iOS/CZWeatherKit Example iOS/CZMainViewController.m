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

@property (nonatomic) NSDictionary  *keys;

@property (nonatomic) CZWeatherView *weatherView;

@end

@implementation CZMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.keys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"API_KEY"
                                                                                              ofType:@"plist"]];
    }
    return self;
}

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
    
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.service = [CZOpenWeatherMapService serviceWithKey:nil];
    request.location[CZWeatherKitLocationName.CoordinateName] = [NSValue valueWithCGPoint:CGPointMake(latitude, longitude)];
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            CZWeatherCondition *condition = (CZWeatherCondition *)data;
            self.weatherView.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.0f°", condition.temperature.f];
        }
    }];
}

@end
