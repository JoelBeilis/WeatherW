//
//  WeatherWApp.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-26.
//

import SwiftUI

@main
struct WeatherWApp: App {
    @State private var locationManager = LocationManager()
    @State private var store = DataStore()
    @State private var temperatureUnit = TemperatureUnit()
    @State private var isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch || !locationManager.isAuthorized {
                let firstCity = store.cities.first ?? City.mockCurrent
                ForecastView(city: firstCity)
                    .environmentObject(temperatureUnit)
                    .onAppear {
                        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
                        print(URL.documentsDirectory.path())
                    }
            } else {
                ForecastView()
                    .environmentObject(temperatureUnit)
                    .onAppear {
                        print(URL.documentsDirectory.path())
                    }
            }
        }
        .environment(locationManager)
        .environment(store)
    }
}
