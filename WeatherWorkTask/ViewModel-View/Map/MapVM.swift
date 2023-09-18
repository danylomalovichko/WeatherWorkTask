//
//  MapVM.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 02.09.2023.
//

import Foundation
import MapKit

@MainActor
class MapVM: BaseVM {
    
    @Published var coordinateRegion: MKCoordinateRegion = .init()
    
    override init(_ container: DependencyContainer) {
        super.init(container)
        
        container.geolocator.currentUserLocation
            .compactMap { $0 }
            .map { coordinate in
                MKCoordinateRegion(
                    center: coordinate.coordinate2D,
                    span: MKCoordinateSpan(
                        latitudeDelta: 2,
                        longitudeDelta: 2)
                )
            }
            .assign(to: &$coordinateRegion)
    }
    
    func setPlace(_ place: Place) {
        container.geolocator.selectedPlace.send(place)
    }
}
