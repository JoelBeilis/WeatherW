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
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(hourlyForecast, id: \.date) { hour in
                    VStack(spacing: 0) {
                        Text(hour.date.localTime(for: timezone))
                        Divider()
                        Spacer()
                        Image(hour.symbolName) // Changed from systemName to name
                            .resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 60, height: 60) // Set the size of the image
                            .padding(.bottom,3)
                        if hour.precipitationChance > 0 {
                            Text("\((hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                .foregroundStyle(.cyan)
                                .bold()
                        }
                        Spacer()
                        Text(weatherManager.temperatureFormatter.string(from: hour.temperature))
                    }
                }
            }
            .font(.system(size: 13))
            .frame(height: 100)
        }
        .contentMargins(.all, 15, for: .scrollContent)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.2)))
    }
}

