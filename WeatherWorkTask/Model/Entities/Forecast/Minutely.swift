//
//  Minutely.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 09.09.2023.
//

import Foundation

struct Minutely: Codable {
    let time: Date
    let values: ForecastValue
}
