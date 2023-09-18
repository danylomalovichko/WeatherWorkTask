//
//  AddressRow.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 05.09.2023.
//

import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                
                Text(address.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Text(address.subtitle)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                
            }
        }
        .padding(.bottom, 2)
    }
}
