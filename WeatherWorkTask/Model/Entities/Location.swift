//
//  Location.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 25.04.2022.
//

import CoreLocation

struct Location: Equatable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let accuracy: Double
    let dateTaken: Date

    public init(latitude: Double = 0, longitude: Double = 0, altitude: Double = 0, accuracy: Double = 0, dateTaken: Date = .init()) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.accuracy = accuracy
        self.dateTaken = dateTaken
    }
    
    var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
