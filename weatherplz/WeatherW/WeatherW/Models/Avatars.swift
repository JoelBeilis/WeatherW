//
//  Avatars.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-31.
//

import UIKit
import CoreLocation
import WeatherKit
import SwiftUI

class Avatars: NSObject {
    
    static let weatherThemes: [String: String] = [
        "IS1_Monkey_": "IS1_Monkey_"
        // Add other themes if needed
    ]
    
    static var curWeatherCharacter: String = "IS1_Monkey_"
    
    static func getWeatherBoyIcon(for temperature: Double, weatherCondition: String) -> String {
        var temperatureCode = ""
        
        if temperature < 0 {
            temperatureCode = "b0"
        } else if temperature < 10 {
            temperatureCode = "0to9"
        } else if temperature < 15 {
            temperatureCode = "10to14"
        } else if temperature < 20 {
            temperatureCode = "15to19"
        } else if temperature < 24 {
            temperatureCode = "20to23"
        } else if temperature < 28 {
            temperatureCode = "24to27"
        } else {
            temperatureCode = "g28"
        }
        
        var weatherCode = ""
        if weatherCondition == "clear-day" || weatherCondition == "clear-night" {
            weatherCode = "sunny"
        } else if weatherCondition == "rain" || weatherCondition == "sleet" || weatherCondition == "snow" || weatherCondition == "hail" {
            weatherCode = "cloudburst"
        } else {
            weatherCode = "rainy"
        }
        
        let theme = weatherThemes[curWeatherCharacter] ?? ""
        return theme + temperatureCode + "_" + weatherCode
    }
}



//static let clothingLabelNames = [
//    "clear-day" : "Sunscreen, Hat, Sunglasses ",
//    "clear-night" : "Jacket or Sweater",
//    "rain" : " Raincoat, Rainboots",
//    "snow" : "Jacket, Hat, Gloves",
//    "sleet" : "Jacket, Hat, Gloves",
//    "wind" : "Wind breaker",
//    "fog" : "Jacket or Sweater",
//    "cloudy" : "Jacket or Sweater",
//    "partly-cloudy-day" : "Jacket or Sweater",
//    "partly-cloudy-night" : "Jacket or Sweater",
//    "hail" : "Jacket, Hat, Gloves",
//    "thunderstorm" : "Raincoat, Rainboots",
//    "tornado" : "Jacket, Hat, Sweater",
//]
