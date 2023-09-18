//
//  DependencyContainer.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 02.09.2023.
//

import Foundation

@MainActor
class DependencyContainer {
    
   let geolocator: GeolocatorService
   let network: NetworkService

    init() {
        geolocator = GeolocatorManager()
        network = NetworkManager()
    }
}
