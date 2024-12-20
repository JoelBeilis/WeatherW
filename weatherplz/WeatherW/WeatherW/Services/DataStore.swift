//
//  DataStore.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import Foundation

@Observable
class DataStore {
    var forPreviews: Bool
    var cities: [City] = []
    let filemanager = FileManager()
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
        if cities.isEmpty {
            cities = City.cities // Populate with default cities
            saveCities() // Save the initial cities to persist them
        }
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            if filemanager.fileExists() {
                do {
                    let data = try filemanager.readFile()
                    cities = try JSONDecoder().decode([City].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveCities() {
        if !forPreviews {
            do {
                let data = try JSONEncoder().encode(cities)
                let jsonString = String(decoding: data, as: UTF8.self)
                try filemanager.saveFile(contents: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
