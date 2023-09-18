//
//  NetworkService.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 07.07.2023.
//

import Alamofire
import Combine
import Foundation

@MainActor
protocol NetworkService {
    func fetchForecast(location: Location) -> AnyPublisher<DataResponse<ForecastResult, NetworkError>, Never>
}

class NetworkManager: NetworkService {
    let server = "https://api.tomorrow.io"
    let apiKey = "xYi7DjC1eoQDGDhvrElfPMGzemIdTiKV"
    
    func fetchForecast(location: Location) -> AnyPublisher<DataResponse<ForecastResult, NetworkError>, Never> {
        let url = URL(string: "\(server)/v4/weather/forecast?location=\(location.latitude),\(location.longitude)&apikey=\(apiKey)")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: ForecastResult.self, decoder: JSONDecoder.decoder)
            .map { response in
                response.mapError { error in
                    let backendError = response.data
                        .flatMap {
                            try? JSONDecoder.decoder.decode(BackendError.self, from: $0)
                        }
                    
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .eraseToAnyPublisher()
    }
}
