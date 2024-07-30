//
//  CurrentWeatherView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

//Image(currentWeather.symbolName) // Changed from systemName to name
//    .resizable() // Make the image resizable
//    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
//    .frame(width: 60, height: 60) // Set the size of the image


import Foundation
import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: String?
    let lowTemperature: String?
    let timezone: TimeZone
    var body: some View {
        Text(currentWeather.date.localDate(for: timezone))
        Text(currentWeather.date.localTime(for: timezone))
        Image(currentWeather.symbolName) // Changed from systemName to name
            .resizable() // Make the image resizable
            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
            .frame(width: 60, height: 60) // Set the size of the image
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.secondary.opacity(0.2))
            )
        let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
        Text(temp)
            .font(.title2)
        if let highTemperature, let lowTemperature {
            Text("H: \(highTemperature)  L:\(lowTemperature)")
                .bold()
        }
        Text(currentWeather.condition.description)
            .font(.title3)
    }
}


