//
//  CityVM.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 06.09.2023.
//

import Foundation
import Combine
import MapKit

@MainActor
class CityVM: NSObject, ObservableObject {
    
    let container: DependencyContainer
    
    struct Props: Hashable {
    }
    
    let props: Props
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""
    
    init(_ container: DependencyContainer, props: Props) {
        self.props = props
        self.container = container
    }
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else {
            return
        }
        localSearchCompleter.queryFragment = searchableText
        localSearchCompleter.resultTypes = .address
    }
    
    func setPlace(_ address: AddressResult) {
        container.geolocator.setPlaceOnAddress(address)
    }
}

extension CityVM: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        Task { @MainActor in
            results = completer.results
                .map {
                    AddressResult(title: $0.title, subtitle: $0.subtitle)
                }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
