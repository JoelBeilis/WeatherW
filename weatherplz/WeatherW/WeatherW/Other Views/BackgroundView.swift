//
//  BackgroundView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI
import WeatherKit

struct BackgroundView: View {
    let condition: WeatherCondition
    let isDaylight: Bool

    var body: some View {
        Image(isDaylight ? condition.rawValue : "night")
            .resizable() // Ensure the image covers the entire background
            .scaledToFill() // Ensure the image scales properly to fill the view
            .blur(radius: 5)
            .colorMultiply(.white.opacity(0.7))
            .edgesIgnoringSafeArea(.all) // Ensure the background covers the entire screen
    }
}

#Preview {
    BackgroundView(condition: .cloudy, isDaylight: false)
}
