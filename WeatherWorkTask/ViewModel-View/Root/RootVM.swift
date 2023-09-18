//
//  RootVM.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 04.09.2023.
//

import Foundation

@MainActor
class RootVM: ObservableObject {
    let container: DependencyContainer
    
    init(_ container: DependencyContainer) {
        self.container = container
    }
}
