//
//  JSONDecoder.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 07.07.2023.
//

import Foundation

extension JSONDecoder {
    static let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
