//
//  RootView.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 04.09.2023.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HomeView(vm: .init(appState.container))
    }
}
