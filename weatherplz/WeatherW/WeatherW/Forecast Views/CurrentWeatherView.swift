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

import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: String?
    let lowTemperature: String?
    let timezone: TimeZone

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(currentWeather.date.localDate(for: timezone))
                    Text(currentWeather.date.localTime(for: timezone))
                    Image(currentWeather.symbolName) // Changed from systemName to name
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                        .frame(width: 60, height: 60) // Set the size of the image
                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 20).fill(.secondary.opacity(0.2)))
                    let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                    Text(temp)
                        .font(.largeTitle)
                    let feelTemp = weatherManager.temperatureFormatter.string(from: currentWeather.apparentTemperature)
                    Text("Feels like: \(feelTemp)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                let imageName = Avatars.getWeatherBoyIcon(for: currentWeather.temperature.value, weatherCondition: currentWeather.condition.rawValue)
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200) // Adjust the size as needed
                    .padding(.leading, 15)
            }
            
            HStack {
                Text(currentWeather.condition.description)
                    .font(.callout)
                Spacer()
                if let highTemperature = highTemperature, let lowTemperature = lowTemperature {
                    Text("L: \(lowTemperature)     H: \(highTemperature)")
                        .bold()
                }
            }
            .padding(.horizontal)
        }
    }
}
