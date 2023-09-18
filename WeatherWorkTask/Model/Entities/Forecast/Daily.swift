//
//  Daily.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 09.09.2023.
//

import Foundation

struct Daily: Codable {
    let time: Date
    let values: ForecastDailyValue
}
