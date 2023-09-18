//
//  NetworkError.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 10.09.2023.
//

import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}
