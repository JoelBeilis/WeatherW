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


import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: Measurement<UnitTemperature>?
    let lowTemperature: Measurement<UnitTemperature>?
    let timezone: TimeZone
    @EnvironmentObject var temperatureUnit: TemperatureUnit

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(currentWeather.date.localDate(for: timezone))
                    Text(currentWeather.date.localTime(for: timezone))
                    Image(currentWeather.symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .padding()

                    // Convert and display current temperature based on the selected unit
                    let temperature = convertedTemperature(currentWeather.temperature)
                    let tempString = weatherManager.temperatureFormatter.string(from: temperature)
                    Text(tempString)
                        .font(.largeTitle)
                        .onAppear {
                            print("Current temperature: \(tempString) \(temperature.unit.symbol)")
                        }

                    // Convert and display "Feels like" temperature based on the selected unit
                    let feelTemperature = convertedTemperature(currentWeather.apparentTemperature)
                    let feelTempString = weatherManager.temperatureFormatter.string(from: feelTemperature)
                    Text("Feels like: \(feelTempString)")
                        .font(.caption)
                        .onAppear {
                            print("Feels like: \(feelTempString) \(feelTemperature.unit.symbol)")
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                let imageName = Avatars.getWeatherBoyIcon(for: currentWeather.temperature.value, weatherCondition: currentWeather.condition.rawValue)
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 230, height: 230)
                    .padding(.leading, 15)
            }

            HStack {
                Text(currentWeather.condition.description)
                    .font(.callout)
                Spacer()
                if let highTemperature, let lowTemperature {
                    // Convert and display high and low temperatures based on the selected unit
                    let highTemp = convertedTemperature(highTemperature)
                    let lowTemp = convertedTemperature(lowTemperature)

                    let highTempString = weatherManager.temperatureFormatter.string(from: highTemp)
                    let lowTempString = weatherManager.temperatureFormatter.string(from: lowTemp)

                    Text("L: \(lowTempString)     H: \(highTempString)")
                        .bold()
                        .onAppear {
                            print("High temperature: \(highTempString) \(highTemp.unit.symbol)")
                            print("Low temperature: \(lowTempString) \(lowTemp.unit.symbol)")
                        }
                }
            }
            .padding(.horizontal)
        }
    }

    // Helper function to convert temperatures based on the selected unit
    func convertedTemperature(_ temperature: Measurement<UnitTemperature>) -> Measurement<UnitTemperature> {
        if temperatureUnit.isCelsius {
            print("Converting to Celsius")
            return temperature
        } else {
            print("Converting to Fahrenheit")
            return temperature.converted(to: .fahrenheit)
        }
    }
}
