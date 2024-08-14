//
//  ForecastView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-26.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var hourlyForecast: Forecast<HourWeather>?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var isLoading = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
    var highTemperature: Measurement<UnitTemperature>? {
        if let high = hourlyForecast?.map({ $0.temperature }).max() {
            return high
        } else {
            return nil
        }
    }
    
    var lowTemperature: Measurement<UnitTemperature>? {
        if let low = hourlyForecast?.map({ $0.temperature }).min() {
            return low
        } else {
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let selectedCity {
                    if isLoading {
                        ProgressView()
                        Text("Fetching Weather...")
                    } else {
                        HStack {
                            Text(selectedCity.name)
                                .font(.system(size: 24, weight: .heavy))
                                .padding(.leading, 15)
                            if selectedCity == locationManager.currentLocation {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let currentWeather {
                            CurrentWeatherView(
                                currentWeather: currentWeather,
                                highTemperature: highTemperature,
                                lowTemperature: lowTemperature,
                                timezone: timezone
                            )
                        }
                        if let hourlyForecast {
                            HourlyForecastView(
                                hourlyForecast: hourlyForecast,
                                timezone: timezone
                            )
                        }
                        if let dailyForecast {
                            DailyForecastView(dailyForecast: dailyForecast, timezone: timezone)
                        }
                        AttributionView()
                            .tint(.white)
                    }
                }
            }
        }
        .contentMargins(.all, 15, for: .scrollContent)
        .background {
            if let condition = currentWeather?.condition, let isDaylight = currentWeather?.isDaylight {
                BackgroundView(condition: condition, isDaylight: isDaylight)
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            Button {
                showCityList.toggle()
            } label: {
                Image(systemName: "list.star")
            }
            .padding()
            .background(Color(.darkGray))
            .clipShape(.circle)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .fullScreenCover(isPresented: $showCityList) {
            CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                selectedCity = locationManager.currentLocation
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
            dailyForecast = await weatherManager.dailyForecast(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
}

