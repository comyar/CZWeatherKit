![](header.png)

[![Build Status](https://travis-ci.org/comyarzaheri/CZWeatherKit.svg?branch=master)](https://travis-ci.org/CZWeatherKit/CZWeatherKit)
![License](http://img.shields.io/badge/license-MIT-33e0ff.svg)

CZWeatherKit is a simple, extensible weather library for iOS and OS X that allows for easy fetching of weather data from various weather services.

#### What's New in v2.0

###### Features

* New architecture.
* Support for historical and hourly data, [Issue #14](https://github.com/comyarzaheri/CZWeatherKit/issues/14).
* Addition of more data, including humidity, wind speed, and more.

###### Bug Fixes

* Overall improved testing 
* Improved JSON parsing, [Issue #16](https://github.com/comyarzaheri/CZWeatherKit/issues/16).
* Fixed issue where Climacons were only correct for English language data, [Issue #12](https://github.com/comyarzaheri/CZWeatherKit/issues/12).

###### What's next?

* Better support for use cases that require frequent requests (i.e. like a weather app)
* Built-in caching support

# Getting Started

### Cocoa Pods

Add the following to your Podfile:

```ruby
    pod "CZWeatherKit"
```

# Usage

Included in this project is a Swift playground, `CZWeatherKit.playground`, that will let you play around with `CZOpenWeatherMapRequest`. However if you're as lazy as I am, here are some code snippets to get you started:

### Wunderground

###### Getting Current Conditions, Obj-C

```objc
#import <CZWeatherKit/CZWeatherKit.h>

CZWundergroundRequest *request = [CZWundergroundRequest newConditionsRequest];
request.location = [CZWeatherLocation locationForCity:@"Seattle" state:@"WA"];
request.key = @"wundergroundApiKey";
[request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
	CZWeatherCurrentCondition *condition = date.current;
	// dreams come true here
}];
```
###### Getting Forecast Conditions, Swift

```swift
import CZWeatherKit

let request = CZWundergroundRequest.newForecastRequest()
request.location = CZWeatherLocation(fromCity: "Seattle", country: "WA")
request.key = "wundergroundApiKey"
request.sendWithCompletion { (data, error) -> Void in
    if let weather = data {
  		for forecast in weather.dailyForecasts {
  			// dreams come true here
  		}
    }
}
```

## OpenWeatherMap

###### Getting Current Conditions, Obj-C

```objc
#import <CZWeatherKit/CZWeatherKit.h>

CZOpenWeatherMap *request = [CZOpenWeatherMap newCurrentRequest];
request.location = [CZWeatherLocation locationForCity:@"Seattle" state:@"WA"];
[request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
	CZWeatherCurrentCondition *condition = date.current;
	// dreams come true here
}];
```

###### Getting Forecast Conditions, Swift

```swift
import CZWeatherKit

let request = CZOpenWeatherMapRequest.newDailyForecastRequestForDays(3)
request.location = CZWeatherLocation(fromCity: "Seattle", country: "WA")
request.sendWithCompletion { (data, error) -> Void in
    if let weather = data {
  		for forecast in weather.dailyForecasts {
  			// dreams come true here
  		}
    }
}
```

## Supported Weather APIs

CZWeatherKit currently supports the following weather services:

* [Weather Underground](http://www.wunderground.com/weather/api/)
* [Open Weather Map](http://openweathermap.org/API)
* [Forecast.io](https://developer.forecast.io)
* <del>[World Weather Online](https://developer.worldweatheronline.com)</del> : World Weather Online support hasn't made its way into 2.0 yet; there is an outstanding [issue](https://github.com/comyarzaheri/CZWeatherKit/issues/17) for adding support. To give me a sense of how important this is to users, please leave a `+1` in the comments of the issue if you need this feature.

## Climacons

CZWeatherKit supports Climacons out of the box. The [Climacons Font](http://adamwhitcroft.com/climacons/font/) is a font set created by [Adam Whitcroft](http://adamwhitcroft.com/) featuring weather icons. 

# Architecture 

| Model Type | Description |
|:--------|:------------|
| `CZWeatherLocation` | Represents a location to retrieve weather data for. |
| `CZWeatherData` | Top-level container for all other weather data. |
| `CZWeatherCurrentCondition` | Contains data for current conditions. |
| `CZWeatherForecastCondition` | Contains data for a day's forecasted conditions. |
| `CZWeatherHourlyCondition` | Contains data for an hour's conditions. |
| `CZWeatherRequest` | The abstract base class for all request classes. |
| `CZWundergroundRequest` | Used for calling the Wunderground API.  |
| `CZOpenWeatherMapRequest` | Used for calling the OpenWeatherMap API.  |
| `CZForecastioRequest` | Used for calling the Forecast.io API.  |
| `CZWorldWeatherOnlineRequest` | Used for calling the World Weather Online API. 

| API Type | Description |
|:---|:-------------|
| `CZWundergroundAPI` | Wunderground API class. |
| `CZOpenWeatherMapAPI ` | OpenWeatherMap API class. |
| `CZForecastioAPI` | Forecastio API class. |
| `CZWorldWeatherOnlineAPI` | WorldWeatherOnline API class. |

| Protocols | Description |
|:---|:-------------|
| `CZWeatherAPI` | The protocol for weather API classes. |

| Headers | Description |
|:---|:-------------|
| `CZClimacons` | Contains mappings for Climacons to chars. |
| `CZWeatherKitTypes` | Contains varions type definitions. |

# Contributing

If you would like to contribute to the development of CZWeatherKit, please take care to follow the style conventions and please include unit tests in your pull request.

For feature requests or general questions, feel free to post an issue.

### Contributers

* Comyar Zaheri, [@comyarzaheri](https://github.com/comyarzaheri)
* Eli Perkins, [@eliperkins](https://github.com/eliperkins)
* Seb Jachec, [@sebj](https://github.com/sebj)

