//
//  ContentViewVM.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 02.09.2023.
//

import SwiftUI

@MainActor
class HomeVM: BaseVM {
    
    private let geolocator: GeolocatorService
    
    @Published var timelines: Timelines?
    @Published var forecastMinutelytLast: Minutely?
    
    @Published var selectedPlace: Place?
    
    @Published var showingAlert = false
    @Published var errorMessage: String?
    
    override init(_ container: DependencyContainer) {
        geolocator = container.geolocator
        
        super.init(container)
        
        setup()
        
        $timelines
            .sink { items in
                self.forecastMinutelytLast = items?.minutely.last
            }
            .store(in: &bag)
        
        geolocator.selectedPlace
            .eraseToAnyPublisher()
            .assign(to: &$selectedPlace)
        
        $selectedPlace
            .compactMap { $0 }
            .sink { place in
                self.fetchForecast(location: place.location)
            }
            .store(in: &bag)
    }
    
    private func setup() {
        switch geolocator.currentAuthorizationStatus {
        case .notDetermined:
            geolocator.requestAlwaysAuthorizationIfNotDetermined()
        case .authorized:
            geolocator.enableLocationTracking()
        case .denied:
            print("denied")
        }
    }
    
    func fetchForecast(location: Location) {
        container.network.fetchForecast(location: location )
            .sink { dataResponse in
                if dataResponse.error != nil {
                    guard let error = dataResponse.error else {
                        return
                    }
                    self.errorMessage = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
                    self.showingAlert = true
                } else {
                    self.timelines = dataResponse.value?.timelines
                }
            }
            .store(in: &bag)
    }
}
