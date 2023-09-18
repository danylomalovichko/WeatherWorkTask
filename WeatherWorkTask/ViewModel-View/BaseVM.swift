//
//  BaseVM.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 04.09.2023.
//

import Combine

@MainActor
class BaseVM: ObservableObject {
    
    let container: DependencyContainer
    internal var bag = Set<AnyCancellable>()
    
    init(_ container: DependencyContainer) {
        self.container = container
    }
}
