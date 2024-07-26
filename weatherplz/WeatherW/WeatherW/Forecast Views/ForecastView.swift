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
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                Text("Fetching Weather...")
            } else {
                if let currentWeather {
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                    Image(currentWeather.symbolName) // Changed from systemName to name
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                        .frame(width: 60, height: 60) // Set the size of the image
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary.opacity(0.2))
                        )
                    let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                    Text(temp)
                        .font(.title2)
                    Text(currentWeather.condition.description)
                        .font(.title3)
                    AttributionView()
                }
            }
        }
        .padding()
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
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
}
