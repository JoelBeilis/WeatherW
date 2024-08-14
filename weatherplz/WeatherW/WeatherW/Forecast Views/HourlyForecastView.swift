//
//  HourlyForecastView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    let weatherManager = WeatherManager.shared
    let hourlyForecast: Forecast<HourWeather>
    let timezone: TimeZone
    @EnvironmentObject var temperatureUnit: TemperatureUnit // Access the global temperature unit

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(hourlyForecast.enumerated()), id: \.element.date) { index, hour in
                    VStack(spacing: 5) {
                        Text(index == 0 ? "Now" : hour.date.localTime(for: timezone))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(hour.symbolName) // Show weather icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        if hour.precipitationChance > 0 {
                            Text("\((hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.mint)
                                .bold()
                        }
                        
                        // Convert and display temperature based on the selected unit
                        let temperature = convertedTemperature(hour.temperature)
                        Text(weatherManager.temperatureFormatter.string(from: temperature))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 70, height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.primary.opacity(index == 0 ? 0.3 : 0.1)) // Thicker opacity for the first cell
                    )
                }
            }
            .padding(.horizontal, 3)
        }
    }
    
    // Helper function to convert temperatures based on the selected unit
    func convertedTemperature(_ temperature: Measurement<UnitTemperature>) -> Measurement<UnitTemperature> {
        return temperatureUnit.isCelsius ? temperature : temperature.converted(to: .fahrenheit)
    }
}
