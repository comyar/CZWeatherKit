//
//  CZWeatherKit.playground
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

import CZWeatherKit
import XCPlayground
/*:
This allows asynchronous operations to complete in our playground. 
[NSHipster](http://nshipster.com/xcplayground/#asynchronous-execution) has a 
section that goes over this in more detail.

Set this to `true` to use this playground.
*/
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: false)
/*:
We're going to use this location for the playground.
*/
let location = CZWeatherLocation(fromLatitude: 47.6097, longitude: -122.3331)
/*:
# Getting the Current Conditions
This example shows how to get the current conditions from the [Open Weather Map
API.](http://openweathermap.org/api)
Getting the current conditions from other APIs is just as simple. 
*/
var request = CZOpenWeatherMapRequest.newCurrentRequest()
request.location = location
request.sendWithCompletion { (data, error) -> Void in
    if let weather = data {
        println("The current weather in Seattle, WA is:")
        println("\(weather.current.summary), at \(weather.current.temperature.f)° F")
        println("\(weather.current.humidity)% Humidity")
        println("Wind speed is \(weather.current.windSpeed.mph) mph, bearing \(weather.current.windDirection)°")
    } else {
        println("Failed to get current weather :(")
    }
}
/*:
# Getting the Forecasted Conditions
This example shows how to get the forecast conditions for the next 3 days from 
the [Open Weather Map API.](http://openweathermap.org/api)
*/
request = CZOpenWeatherMapRequest.newDailyForecastRequestForDays(3)
request.location = location
request.sendWithCompletion { (data, error) -> Void in
    if let weather = data {
        for forecast in weather.dailyForecasts {
            println("\(forecast.summary), H:\(forecast.highTemperature.f)° L:\(forecast.lowTemperature.f)°)")
        }
    } else {
        println("Something went wrong :(")
    }
}

/*:
# Using a Weather Service
This is an example showing how to use a weather service. As you can see it's
pretty similar to CZWeatherRequest's API however a service can be configured
with a cache, allows for user configuration of the NSURLSession it's using, and
can manage your API key if you're calling an API that requires one. For 
simplicity, this example doesn't get into all that but feel free to experiment
with those features in this playground.
*/
let service = CZWeatherService()
request = CZOpenWeatherMapRequest.newCurrentRequest()
request.location = location
service.dispatchRequest(request, completion: { (data, error) -> Void in
    if let weather = data {
        for forecast in weather.dailyForecasts {
            println("\(forecast.summary), H:\(forecast.highTemperature.f)° L:\(forecast.lowTemperature.f)°)")
        }
    } else {
        println("Something went wrong :(")
    }
})


