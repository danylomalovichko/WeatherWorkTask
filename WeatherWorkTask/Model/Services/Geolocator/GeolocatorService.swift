//
//  Geolocator.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 25.04.2022.
//

import MapKit
import Combine

@MainActor
protocol GeolocatorService {
    var currentAuthorizationStatus: GeolocatorManager.AuthorizationStatus { get }
    var authorizationStatusPublisher: CurrentValueSubject<GeolocatorManager.AuthorizationStatus, Never> { get }
    
    var currentUserLocation: CurrentValueSubject<Location?, Never> { get }
    
    var selectedPlace: CurrentValueSubject<Place?, Never> { get set }
    
    func requestAlwaysAuthorizationIfNotDetermined()
    func requestWhenInUseAuthorizationIfNotDetermined()
    
    func enableLocationTracking()
    func disableLocationTracking()
    
    func addressFromLocation(_ location: CLLocationCoordinate2D) async throws -> String
    func setPlaceOnAddress(_ address: AddressResult)
}

final class GeolocatorManager: NSObject, GeolocatorService {
    
    enum AuthorizationStatus {
        case authorized
        case denied
        case notDetermined
    }
    
    let authorizationStatusPublisher = CurrentValueSubject<GeolocatorManager.AuthorizationStatus, Never>(.notDetermined)
    
    let currentUserLocation = CurrentValueSubject<Location?, Never>(nil)
    var selectedPlace = CurrentValueSubject<Place?, Never>(nil)
    
    
    private(set) var lastLocation: Location?
    private(set) var locationTrackingEnabled = false
    
    var currentAuthorizationStatus: GeolocatorManager.AuthorizationStatus {
        makeAuthorizationStatus()
    }
    
    private let locationManager: CLLocationManager
    
    public override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        authorizationStatusPublisher.send(makeAuthorizationStatus())
        
        locationManager.delegate = self
        
        startIfAuthorized()
    }
    
    private func startIfAuthorized() {
        switch currentAuthorizationStatus {
        case .authorized:
            enableLocationTracking()
        default:
            break
        }
    }
    
    public func requestWhenInUseAuthorizationIfNotDetermined() {
        switch authorizationStatusPublisher.value {
        case .authorized, .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func requestAlwaysAuthorizationIfNotDetermined() {
        switch authorizationStatusPublisher.value {
        case .authorized, .denied:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func enableLocationTracking() {
        guard authorizationStatusPublisher.value == .authorized, !locationTrackingEnabled else { return }
        
        locationTrackingEnabled = true
        locationManager.startUpdatingLocation()
        
        if let clLocation = locationManager.location {
            lastLocation = makeLocation(from: clLocation)
        }
        
        print("Location tracking enabled.")
    }
    
    public func disableLocationTracking() {
        guard locationTrackingEnabled else { return }
        
        locationManager.stopUpdatingLocation()
        locationTrackingEnabled = false
        lastLocation = nil
        
        print("Location tracking disabled.")
    }
    
    func addressFromLocation(_ coordinate: CLLocationCoordinate2D) async throws -> String {
        do {
            let geocoder: CLGeocoder = CLGeocoder()
            let placeLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let address: String = try await withCheckedThrowingContinuation { continuation in
                geocoder.reverseGeocodeLocation(placeLocation, completionHandler: { (placemarks, error) in
                    if let error = error {
                        debugPrint("Reverse geodcode fail: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                    
                    guard let placemark = placemarks?[0]  else {
                        continuation.resume(throwing: BaseError.somethingWhenWrong(message: "Reverse geodcode fail: placemarks is null"))
                        return
                    }
                    let addressString = [
                        placemark.subLocality,
                        placemark.locality
                    ]
                        .compactMap({ $0 })
                        .joined(separator: ",")
                    
                    continuation.resume(returning: addressString)
                })
            }
            return address
        } catch {
            throw error
        }
    }
    
    func setPlaceOnAddress(_ address: AddressResult) {
        let searchRequest = MKLocalSearch.Request()
        let title = address.title
        let subTitle = address.subtitle
        
        searchRequest.naturalLanguageQuery = subTitle.contains(title) ? subTitle : title + ", " + subTitle
        
        Task {
            let response = try await MKLocalSearch(request: searchRequest).start()
            guard let item = response.mapItems.first else {
                return
            }
            
            await MainActor.run {
                let location = Location(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                let place = Place(name: title + ", " + subTitle, location: location)
                self.selectedPlace.send(place)
            }
        }
    }
    
    private func makeLocation(from clLocation: CLLocation) -> Location {
        Location(latitude: clLocation.coordinate.latitude,
                 longitude: clLocation.coordinate.longitude,
                 altitude: clLocation.altitude,
                 accuracy: clLocation.horizontalAccuracy,
                 dateTaken: clLocation.timestamp)
    }
    
    private func makeAuthorizationStatus() -> AuthorizationStatus {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined, .restricted:
            return .notDetermined
        @unknown default:
            assertionFailure("Please implement the new authorizationStatus case \(locationManager.authorizationStatus)")
            return .notDetermined
        }
    }
}

extension GeolocatorManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newAuthorizationStatus = makeAuthorizationStatus()
        if authorizationStatusPublisher.value != newAuthorizationStatus {
            authorizationStatusPublisher.send(newAuthorizationStatus)
            
            switch newAuthorizationStatus {
            case .denied, .notDetermined:
                disableLocationTracking()
                print("Location tracking permission is denied.")
            default:
                enableLocationTracking()
                print("Location tracking permission is granted.")
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let rawLocation = locations.last else { return }
        
        if locationTrackingEnabled {
            lastLocation = makeLocation(from: rawLocation)
            currentUserLocation.send(lastLocation)
            print("lastLocation: \(String(describing: lastLocation))")
            
            if selectedPlace.value == nil {
                guard let lastLocation = lastLocation else {
                    return
                }
                Task {
                    let address = try await addressFromLocation(lastLocation.coordinate2D)
                    let place = Place(name: address, location: lastLocation)
                    selectedPlace.send(place)
                }
            }
        }
    }
}
