//
//  BackendError.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 10.09.2023.
//

import Foundation

struct BackendError: Codable, Error {
    let type: String
    let message: String
}
