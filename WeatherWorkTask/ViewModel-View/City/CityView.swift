//
//  CityView.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 06.09.2023.
//

import Foundation
import SwiftUI

struct CityView: View {
    @StateObject var vm: CityVM
    @FocusState private var isFocusedTextField: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                TextField("Type address", text: $vm.searchableText)
                    .padding()
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .onReceive(
                        vm.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        vm.searchAddress($0)
                    }
                    .background(.white)
                    .overlay {
                        ClearButton(text: $vm.searchableText)
                            .padding(.trailing)
                            .padding(.top, 8)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }
                
                List(self.vm.results) { address in
                    AddressRow(address: address) {
                        vm.setPlace(address)
                        dismiss()
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}


// MARK: Views
private extension CityView {
}

// MARK: Functions
private extension CityView {
}
