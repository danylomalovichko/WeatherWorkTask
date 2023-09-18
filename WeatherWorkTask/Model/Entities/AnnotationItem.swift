//
//  AnnotationItem.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 05.09.2023.
//

import CoreLocation

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
