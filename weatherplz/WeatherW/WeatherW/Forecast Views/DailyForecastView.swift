//
//  DailyForecastView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    let weatherManager: WeatherManager = WeatherManager.shared
    let dailyForecast: Forecast<DayWeather>
    let timezone: TimeZone
    @State private var barWidth: Double = 0


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                let maxDayTemp = dailyForecast.map { $0.highTemperature.value }.max() ?? 0
                let minDayTemp = dailyForecast.map { $0.lowTemperature.value }.min() ?? 0
                let tempRange = maxDayTemp - minDayTemp

                ForEach(dailyForecast.indices, id: \.self) { index in
                    let day = dailyForecast[index]

                    HStack(spacing: 10) {
                        // Date on the far left
                        Text(index == 0 ? "Today" : day.date.localWeekDay(for: timezone))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 70, alignment: .leading)

                        // Weather icon clipped 5px away from the date
                        VStack(spacing: 2) {
                            Image(day.symbolName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding(.leading, -20) // Clipping the icon 5px closer to the date
                            if day.precipitationChance > 0 {
                                Text("\((day.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.mint)
                                    .padding(.leading, -20)
                            }
                        }
                        .frame(width: 45, alignment: .leading) // Adjust width to provide more space for the scale

                        // Low temperature
                        Text(weatherManager.temperatureFormatter.string(from: day.lowTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, alignment: .leading)
                            .padding(.leading, -20)

                        // Temperature scale (visual representation of the range)
                        RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.secondary.opacity(0.1))
                                                        .frame(height: 5)
                                                        .readSize { size in
                                                            barWidth = size.width
                                                        }
                                                        .overlay {
                                                            let degreeFactor = barWidth / tempRange
                                                            let dayRangeWidth = (day.highTemperature.value - day.lowTemperature.value) * degreeFactor
                                                            let xOffset = (day.lowTemperature.value - minDayTemp) * degreeFactor
                                                            HStack {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(
                                                                        LinearGradient(
                                                                            gradient: Gradient(
                                                                                colors: [
                                                                                    .green,
                                                                                    .orange
                                                                                ]
                                                                            ),
                                                                            startPoint: .leading,
                                                                            endPoint: .trailing
                                                                        )
                                                                    )
                                                                    .frame(width: dayRangeWidth, height: 5)
                                                                Spacer()
                                                            }
                                                            .offset(x: xOffset)
                                                        }

                        .padding(.horizontal, 2) // Add 2px padding around the bar

                        // High temperature on the far right
                        Text(weatherManager.temperatureFormatter.string(from: day.highTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(.vertical, 5) // Reduced vertical padding to make it more compact
                    .frame(height: 40) // Ensure the height is consistent
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.primary.opacity(0.1))
                    .frame(width: UIScreen.main.bounds.width - 20) // Adjusted width for the entire box
            )
            .padding(.horizontal, 10) // Add some horizontal padding around the box
        }
    }
}

