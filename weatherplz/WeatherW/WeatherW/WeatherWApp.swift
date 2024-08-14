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
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
                    .environmentObject(temperatureUnit)
                    .onAppear {
                        print(URL.documentsDirectory.path())
                    }
            } else {
                LocationDeniedView()
                    .environmentObject(temperatureUnit)
            }
        }
        .environment(locationManager)
        .environment(store)
    }
}
