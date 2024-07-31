//
//  DailyForecastView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    let weatherManager = WeatherManager.shared
    let dailyForecast: Forecast<DayWeather>
    @State private var barWidth: Double = 0
    let timezone: TimeZone

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                let maxDayTemp = dailyForecast.map { $0.highTemperature.value }.max() ?? 0
                let minDayTemp = dailyForecast.map { $0.lowTemperature.value }.min() ?? 0
                let tempRange = maxDayTemp - minDayTemp

                ForEach(dailyForecast.indices, id: \.self) { index in
                    let day = dailyForecast[index]
                    
                    HStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(index == 0 ? "Today" : day.date.localWeekDay(for: timezone))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)

                            Image(day.symbolName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)

                            if day.precipitationChance > 0 {
                                Text("\((day.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.mint)
                                    .bold()
                            }
                        }
                        .frame(width: 60)

                        Text(weatherManager.temperatureFormatter.string(from: day.lowTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, alignment: .leading)

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

                        Text(weatherManager.temperatureFormatter.string(from: day.highTemperature))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(index == 0 ? 0.3 : 0.1)) // Thicker opacity for the first cell
                            .frame(width: UIScreen.main.bounds.width - 40) // Adjust the width as needed
                    )
                }
            }
            .padding()
        }
    }
}
