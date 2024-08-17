//
//  AvatarPopUp.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-08-16.
//

import Foundation
import SwiftUI

struct AvatarPopupView: View {
    let imageName: String
    let description: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300) // Larger avatar image
                .padding()

            Text(description)
                .font(.title)
//                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the view fills the screen
        .background(Color.black.opacity(0.3)) // Translucent background with low opacity
        .background(BlurView(style: .systemMaterial)) // Add blur effect to make the background more elegant
        .cornerRadius(20) // Optionally, add rounded corners
        .padding()
        .presentationDetents([.medium, .large]) // Enable resizing the popup
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
