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
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
    }
}
