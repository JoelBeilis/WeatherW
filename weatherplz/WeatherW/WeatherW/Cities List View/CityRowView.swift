//
//  CityRowView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

struct CityRowView: View {
    let weatherManager = WeatherManager.shared
    @Environment(LocationManager.self) var locationManager
    @EnvironmentObject var temperatureUnit: TemperatureUnit
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State private var timezone: TimeZone = .current
    let city: City
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let currentWeather {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.title)
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                
                                if city == locationManager.currentLocation {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.white)
                                        .padding(.leading, 5)
                                }
                                
                                Text(currentWeather.date.localTime(for: timezone))
                                    .bold()
                          
                            }
                            Spacer()
                            let temperature = temperatureUnit.isCelsius ? currentWeather.temperature : currentWeather.temperature.converted(to: .fahrenheit)
                            let tempString = weatherManager.temperatureFormatter.string(from: temperature)
                            Text(tempString)
                                .font(.system(size: 60, weight: .thin, design: .rounded))
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        Text(currentWeather.condition.description)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background {
            if let condition = currentWeather?.condition, let isDaylight = currentWeather?.isDaylight {
                BackgroundView(condition: condition, isDaylight: isDaylight)
            }
        }
        .task(id: city) {
            await fetchWeather(for: city)
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    CityRowView(city: City.mockCurrent)
        .environment(LocationManager())
        .environmentObject(TemperatureUnit())
}
