//
//  WeatherWorkTaskApp.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 01.09.2023.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
}

@main
struct WeatherWorkTaskApp: App {
    
    @StateObject var appState = AppState(container: DependencyContainer())
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
