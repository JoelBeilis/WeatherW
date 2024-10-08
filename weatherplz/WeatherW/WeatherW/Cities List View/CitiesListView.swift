//
//  CitiesListView.swift
//  WeatherW
//
//  Created by Joel Beilis on 2024-07-27.
//

import SwiftUI

struct CitiesListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataStore.self) private var store
    @EnvironmentObject var temperatureUnit: TemperatureUnit
    let currentLocation: City?
    @Binding var selectedCity: City?
    @State private var isSearching = false
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search...", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .focused($isFocused)
                    }
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isSearching.toggle()
                        }
                    }
                    List {
                        Group {
                            if let currentLocation {
                                CityRowView(city: currentLocation)
                                    .onTapGesture {
                                        selectedCity = currentLocation
                                        dismiss()
                                    }
                            }
                            ForEach(store.cities) { city in
                                CityRowView(city: city)
                                    .onTapGesture {
                                        selectedCity = city
                                        dismiss()
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            if let index = store.cities.firstIndex(where: { $0.id == city.id }) {
                                                store.cities.remove(at: index)
                                                store.saveCities()

                                                // Update the selected city if it was the one being removed
                                                if selectedCity == city {
                                                    selectedCity = store.cities.first // Update to the next city in the list
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .tint(.red)
                                        .cornerRadius(20)
                                    }
                            }
                            .onMove { indices, newOffset in
                                store.cities.move(fromOffsets: indices, toOffset: newOffset)
                                store.saveCities()
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
                    }

                    .listStyle(.plain)
                    .navigationTitle("My Cities")
                    .navigationBarTitleDisplayMode(.inline)
                    .preferredColorScheme(.dark)
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            HStack(spacing: 10) {
//                                Button(action: {
//                                    temperatureUnit.isCelsius = true
//                                }) {
//                                    Text("Cº")
//                                        .foregroundColor(temperatureUnit.isCelsius ? .white : .gray)
//                                }
//
//                                Button(action: {
//                                    temperatureUnit.isCelsius = false
//                                }) {
//                                    Text("Fº")
//                                        .foregroundColor(!temperatureUnit.isCelsius ? .white : .gray)
//                                }
//                            }
//                        }
//                    }
                }
                if isSearching {
                    SearchOverlay(isSearching: $isSearching)
                        .zIndex(1.0)
                }
            }
        }
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
        .environmentObject(TemperatureUnit())
}
