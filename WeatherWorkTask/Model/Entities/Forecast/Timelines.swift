//
//  Timelines.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 09.09.2023.
//

import Foundation

struct Timelines: Codable {
    let minutely: [Minutely]
    let hourly: [Minutely]
    let daily: [Daily]
}
