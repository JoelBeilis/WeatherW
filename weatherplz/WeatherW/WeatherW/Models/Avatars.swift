//
//  Avatars.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-31.
//

import UIKit
import CoreLocation
import WeatherKit
import SwiftUI

class Avatars: NSObject {

    static let weatherThemes: [String: String] = [
        "IS1_Monkey_": "IS1_Monkey_"
        // Add other themes if needed
    ]
    
    static var curWeatherCharacter: String = "IS1_Monkey_"

    static let clothingLabelNames = [
        "IS1_Monkey_0to9_cloudburst": """
        - Jacket
        - Sweater or hoodie
        - Long pants
        - Hat
        - Scarf
        - Umbrella
        """,
        "IS1_Monkey_0to9_rainy": """
        - Jacket
        - Sweater or hoodie
        - Long pants
        - Hat
        - Scarf
        - Umbrella
        """,
        "IS1_Monkey_0to9_sunny": """
        - Jacket
        - Sweater or hoodie
        - Long pants
        - Hat
        - Scarf
        """,
        "IS1_Monkey_10to14_cloudburst": """
        - Windbreaker or sweater
        - Long pants
        - Umbrella
        """,
        "IS1_Monkey_10to14_rainy": """
        - Windbreaker or sweater
        - Long pants
        - Umbrella
        """,
        "IS1_Monkey_10to14_sunny": """
        - Windbreaker or sweater
        - Long pants
        """,
        "IS1_Monkey_15to19_cloudburst": """
        - Long sleeved shirt
        - Long pants
        - Umbrella
        """,
        "IS1_Monkey_15to19_rainy": """
        - Long sleeved shirt
        - Long pants
        - Umbrella
        """,
        "IS1_Monkey_15to19_sunny": """
        - Long sleeved shirt
        - Long pants
        """,
        "IS1_Monkey_20to23_cloudburst": """
        - Short sleeved shirt
        - Pants
        - Sunhat
        - Umbrella
        """,
        "IS1_Monkey_20to23_rainy": """
        - Short sleeved shirt
        - Pants
        - Sunhat
        - Sunglasses
        - Umbrella
        """,
        "IS1_Monkey_20to23_sunny": """
        - Short sleeved shirt
        - Pants
        - Sunglasses
        - Sunhat
        """,
        "IS1_Monkey_24to27_cloudburst": """
        - Short sleeved shirt
        - Short pants
        - Sunhat
        - Umbrella
        """,
        "IS1_Monkey_24to27_rainy": """
        - Short sleeved shirt
        - Short pants
        - Sunglasses
        - Sunhat
        - Umbrella
        """,
        "IS1_Monkey_24to27_sunny": """
        - Short sleeved shirt
        - Short pants
        - Sunglasses
        - Sunhat
        """,
        "IS1_Monkey_b0_cloudburst": """
        - Jacket
        - Sweater
        - Hat
        - Scarf
        - Gloves
        - Winter boots
        - Umbrella
        """,
        "IS1_Monkey_b0_rainy": """
        - Jacket
        - Sweater
        - Hat
        - Scarf
        - Gloves
        - Winter boots
        - Umbrella
        """,
        "IS1_Monkey_b0_sunny": """
        - Jacket
        - Sweater
        - Hat
        - Scarf
        - Gloves
        - Winter boots
        """,
        "IS1_Monkey_g28_cloudburst": """
        - Shorts
        - Sunhat
        - Umbrella
        """,
        "IS1_Monkey_g28_rainy": """
        - Shorts
        - Sunglasses
        - Sunhat
        - Umbrella
        """,
        "IS1_Monkey_g28_sunny": """
        - Shorts
        - Sunglasses
        - Sunhat
        """
    ]

    static func getWeatherBoyIcon(for temperature: Double, weatherCondition: String) -> String {
        var temperatureCode = ""
        
        if temperature < 0 {
            temperatureCode = "b0"
        } else if temperature < 10 {
            temperatureCode = "0to9"
        } else if temperature < 15 {
            temperatureCode = "10to14"
        } else if temperature < 20 {
            temperatureCode = "15to19"
        } else if temperature < 24 {
            temperatureCode = "20to23"
        } else if temperature < 28 {
            temperatureCode = "24to27"
        } else {
            temperatureCode = "g28"
        }
        
        var weatherCode = ""
        if weatherCondition == "drizzle" || weatherCondition == "blowingDust" || weatherCondition == "blowingSnow" || weatherCondition == "flurries" || weatherCondition == "freezingRain" || weatherCondition == "frigid" || weatherCondition == "partlyCloudy" {
            weatherCode = "rainy"
        } else if weatherCondition == "rain" || weatherCondition == "sleet" || weatherCondition == "heavySnow" || weatherCondition == "heavyRain" || weatherCondition == "snow" || weatherCondition == "hail" || weatherCondition == "isolatedThunderstorms" || weatherCondition == "scatteredThunderstorms" || weatherCondition == "strongStorms" || weatherCondition == "sunShowers" || weatherCondition == "showers" || weatherCondition == "thunderstorms" || weatherCondition == "tropicalStorm" || weatherCondition == "wintryMix" {
            weatherCode = "cloudburst"
        } else {
            weatherCode = "sunny"
        }
        
        let theme = weatherThemes[curWeatherCharacter] ?? ""
        let generatedKey = theme + temperatureCode + "_" + weatherCode
//        print("Generated key: \(generatedKey)") // Debugging: Print the generated key
        return generatedKey
    }

    static func getClothingRecommendation(for temperature: Double, condition: String) -> String {
        let key = getWeatherBoyIcon(for: temperature, weatherCondition: condition)
//        print("Clothing recommendation key: \(key)") // Debugging: Print the key used for lookup
        return clothingLabelNames[key] ?? "Dress appropriately."
    }
}
