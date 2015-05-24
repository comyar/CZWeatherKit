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
XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: false) // <- Set this to true to use playground

let location = CZWeatherLocation(fromCity: "Seattle", country: "WA")

// Getting the current weather
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

// Getting the forecasted weather
request = CZOpenWeatherMapRequest.newDailyForecastRequestForDays(3)
request.location = location
request.sendWithCompletion { (data, error) -> Void in
    if let weather = data {
        for forecast in weather.dailyForecasts {
            println("\(forecast.summary), H:\(forecast.highTemperature.f)° L:\(forecast.lowTemperature.f)°)")
        }
    } else {
        println("Well, they always said you can't predict the future...")
    }
}

// Getting the historical weather
// This requires an API key

let from = NSDate(timeIntervalSince1970: 1427346000)
let to = NSDate(timeIntervalSince1970: 1427432399)
request = CZOpenWeatherMapRequest.newHistoryRequestFrom(from, to: to)
request.location = location
//request.sendWithCompletion { (data, error) -> Void in
//    if let weather = data {
//        for forecast in weather.hourlyForecasts {
//            println("\(forecast.summary), \(forecast.temperature.f)°")
//        }
//    } else {
//        println("Perhaps history really is a mystery...")
//    }
//}
