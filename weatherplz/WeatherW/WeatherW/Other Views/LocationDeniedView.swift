//
//  LocationDeniedView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-26.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("Location Services", systemImage: "gear")
        },
                               description: {
            Text("""
1. Tap on the button below to go to "Privacy and Security"
2. Tap on "Location Services"
3. Locate the "Weather Wear" app and tap on it
4. Change the setting to "While Using the App"
""").multilineTextAlignment(.leading)
        },
                               actions: {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil
                )
                
            }) {
                Text("Open Settings")
            }
            .buttonStyle(.borderedProminent)
        })
    }
}

#Preview {
    LocationDeniedView()
}