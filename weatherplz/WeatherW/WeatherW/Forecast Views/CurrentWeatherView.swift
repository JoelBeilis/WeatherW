//
//  CurrentWeatherView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

//let clothingLabelNames = [
//    "clear-day" : "Sunscreen, Hat, Sunglasses ",
//    "clear-night" : "Jacket or Sweater",
//    "rain" : " Raincoat, Rainboots",
//    "snow" : "Jacket, Hat, Gloves",
//    "sleet" : "Jacket, Hat, Gloves",
//    "wind" : "Wind breaker",
//    "fog" : "Jacket or Sweater",
//    "cloudy" : "Jacket or Sweater",
//    "partly-cloudy-day" : "Jacket or Sweater",
//    "partly-cloudy-night" : "Jacket or Sweater",
//    "hail" : "Jacket, Hat, Gloves",
//    "thunderstorm" : "Raincoat, Rainboots",
//    "tornado" : "Jacket, Hat, Sweater",
//]

import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: Measurement<UnitTemperature>?
    let lowTemperature: Measurement<UnitTemperature>?
    let timezone: TimeZone
    @EnvironmentObject var temperatureUnit: TemperatureUnit
    @State private var showAvatarPopup = false // State to manage the popup

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(currentWeather.date.localDate(for: timezone))
                    Text(currentWeather.date.localTime(for: timezone))
                    Image(currentWeather.symbolName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .padding()

                    let temperature = convertedTemperature(currentWeather.temperature)
                    let tempString = weatherManager.temperatureFormatter.string(from: temperature)
                    Text(tempString)
                        .font(.largeTitle)

                    let feelTemperature = convertedTemperature(currentWeather.apparentTemperature)
                    let feelTempString = weatherManager.temperatureFormatter.string(from: feelTemperature)
                    Text("Feels like: \(feelTempString)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                let imageName = Avatars.getWeatherBoyIcon(for: currentWeather.temperature.value, weatherCondition: currentWeather.condition.rawValue)
                Button(action: {
                    showAvatarPopup.toggle()
                }) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 230, height: 230)
                        .padding(10)
                }
                .sheet(isPresented: $showAvatarPopup) {
                    let recommendation = Avatars.getClothingRecommendation(for: currentWeather.temperature.value, condition: currentWeather.condition.rawValue)
                    AvatarPopupView(imageName: imageName, description: recommendation)
                        .background(Color.clear)
                }
            }

            HStack {
                Text(currentWeather.condition.description)
                    .font(.callout)
                Spacer()
                if let highTemperature, let lowTemperature {
                    let highTemp = convertedTemperature(highTemperature)
                    let lowTemp = convertedTemperature(lowTemperature)

                    let highTempString = weatherManager.temperatureFormatter.string(from: highTemp)
                    let lowTempString = weatherManager.temperatureFormatter.string(from: lowTemp)

                    Text("L: \(lowTempString)     H: \(highTempString)")
                        .bold()
                }
            }
            .padding(.horizontal)
        }
    }

    func convertedTemperature(_ temperature: Measurement<UnitTemperature>) -> Measurement<UnitTemperature> {
        return temperatureUnit.isCelsius ? temperature : temperature.converted(to: .fahrenheit)
    }
}
