//
//  BackgroundView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import Foundation
import SwiftUI
import WeatherKit

import SwiftUI
import WeatherKit

struct BackgroundView: View {
    let condition: WeatherCondition
    var body: some View {
        Image(condition.rawValue)
            .blur(radius: 5)
            .colorMultiply(.white.opacity(0.8))
    }
}

#Preview {
    BackgroundView(condition: .cloudy)
}
