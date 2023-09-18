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
            VStack {
                Text(vm.selectedPlace?.name ?? "")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Text(vm.forecastMinutelytLast?.time ?? Date(), format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Text("Temperature: \(Int(vm.forecastMinutelytLast?.values.temperature ?? 0))°C")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Text("Humidity: \(Int(vm.forecastMinutelytLast?.values.humidity ?? 0))%")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                        
                        Divider()
                            .frame(minHeight: 3)
                            .background(.black)
                            .padding(.top, 15)
                            .padding(.horizontal, 15)
                            .opacity(0.3)
                        
                        Spacer(minLength: 20)
                        
                        ForEach(vm.timelines?.daily ?? [], id: \.time) { daily in
                            
                            Text(daily.time, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                            
                            Text("Temperature Avg: \(Int(daily.values.temperatureAvg))°C")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Text("Humidity Avg: \(Int(daily.values.humidityAvg))%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Divider()
                            
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.top, 15)
                
                HStack(spacing: 20) {
                    NavigationLink(value: 1) {
                        Text("Select on Map")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .padding(.top, 10)
                    }
                    
                    NavigationLink(value: 2) {
                        Text("City Search")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                            .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.5))
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
            .alert(vm.errorMessage ?? "Unknown", isPresented: $vm.showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .background {
                Image("CloudsBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            
        }
    }
}

// MARK: Views
private extension HomeView {
}

// MARK: Functions
private extension HomeView {
}
