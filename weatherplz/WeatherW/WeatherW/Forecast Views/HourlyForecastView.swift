//
//  HourlyForecastView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

import SwiftUI

struct HourlyForecastView: View {
    let weatherManager = WeatherManager.shared
    let hourlyForecast: Forecast<HourWeather>
    let timezone: TimeZone

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(Array(hourlyForecast.enumerated()), id: \.element.date) { index, hour in
                    VStack(spacing: 5) {
                        Text(hour.date.localTime(for: timezone))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(hour.symbolName) // Changed from systemName to name
                            .resizable() // Make the image resizable
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 30, height: 30) // Adjust the size of the image
                            .padding(.bottom, 3)
                        
                        if hour.precipitationChance > 0 {
                            Text("\((hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.cyan)
                                .bold()
                        }
                        
                        Text(weatherManager.temperatureFormatter.string(from: hour.temperature))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width: 95, height: 140) // Increased width from 70 to 90
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.secondary.opacity(index == 0 ? 0.5 : 0.2)) // Thicker opacity for the first cell
                    )
                }
            }
        }
    }
}

