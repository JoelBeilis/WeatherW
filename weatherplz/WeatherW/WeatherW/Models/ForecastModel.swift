//
//  ForecastModel.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-30.
//

import Foundation
import WeatherKit

enum ForecastPeriod {
    case hourly
    case daily
}

struct Forecast: Identifiable {
    var id = UUID()
    var date: Date
    var weather: Weather
    var probability: Int
    var temperature: Int
    var high: Int
    var low: Int
    var location: String
    
    static let hour: TimeInterval = 60 * 60
    static let day: TimeInterval = 60 * 60 * 24

}
