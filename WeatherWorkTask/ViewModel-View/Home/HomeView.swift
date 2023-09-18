//
//  HomeView.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 02.09.2023.
//

import SwiftUI

@MainActor
struct HomeView: View {
    
    @StateObject var vm: HomeVM
    
    var body: some View {
        
        NavigationStack {
            
            Text(vm.selectedPlace?.name ?? "")
                .multilineTextAlignment(.center)
                .font(.system(size: 26, weight: .heavy, design: .rounded))
            
            ScrollView {
                VStack() {
                    Text(vm.forecasMinutelytLast?.time ?? Date(), format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Text("Tempetature: \(vm.forecasMinutelytLast?.values.temperature ?? 0)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Text("Humidity: \(vm.forecasMinutelytLast?.values.humidity ?? 0)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    ForEach(vm.timelines?.daily ?? [], id: \.time) { daily in
                        
                        Text(daily.time, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Text("Tempetature Avg: \(daily.values.temperatureAvg)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        
                        Text("Humidity Avg: \(daily.values.humidityAvg)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                        
                        Divider()

                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            HStack(spacing: 20) {
                NavigationLink(value: 1) {
                    Text("Select on Map")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                
                NavigationLink(value: 2) {
                    Text("City Search")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
            }
            .navigationDestination(for: Int.self) { value in
                switch value {
                case 1:
                    MapView(vm: .init(vm.container))
                case 2:
                    CityView(vm: .init(vm.container, props: .init()))
                default:
                    EmptyView()
                }
            }
        }
        .alert(vm.errorMessage ?? "Unknow", isPresented: $vm.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
}

// MARK: Views
private extension HomeView {
}

// MARK: Functions
private extension HomeView {
}
