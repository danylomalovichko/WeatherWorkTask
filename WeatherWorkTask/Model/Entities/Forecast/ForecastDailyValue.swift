//
//  ForecastDailyValue.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 09.09.2023.
//

import Foundation

import Foundation

struct ForecastDailyValue: Codable {
    let temperatureAvg: Double
    let temperatureMax: Double
    let temperatureMin: Double
    let humidityAvg: Double
    let humidityMax: Double
    let humidityMin: Double
}
