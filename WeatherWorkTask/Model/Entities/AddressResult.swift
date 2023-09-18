//
//  AddressResult.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 05.09.2023.
//

import Foundation
import CoreLocation

struct AddressResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
