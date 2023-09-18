//
//  MapView.swift
//  WeatherWorkTask
//
//  Created by Danylo Malovichko on 01.09.2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @StateObject var vm: MapVM
    
    var mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapHandler(_:)))
        mapView.addGestureRecognizer(tapRecognizer)
        
        mapView.region = vm.coordinateRegion
        mapView.showsUserLocation = true
 
        return mapView
    }
 
    func updateUIView(_ uiView: MKMapView, context: Context) {
 
    }
 
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
 
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
 
        init(_ parent: MapView) {
            self.parent = parent
        }
 
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            addAnnotation(gesture: gesture)
        }
        
        func addAnnotation(gesture: UITapGestureRecognizer) {
            parent.mapView.showsUserLocation = false
            let annotations = parent.mapView.annotations.filter({ !($0 is MKUserLocation) })
            parent.mapView.removeAnnotations(annotations)
            
            let touchPoint = gesture.location(in: gesture.view)
            let touchMapCoordinate = parent.mapView.convert(touchPoint, toCoordinateFrom: parent.mapView)
            
            let location = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                guard let placemark = placemarks?.first else { return }
                let annotation = MKPointAnnotation()
                annotation.coordinate = touchMapCoordinate
                annotation.title = placemark.locality ?? ""
                self.parent.mapView.addAnnotation(annotation)
                
                Task {
                    let place = Place(name: annotation.title ?? "Not found", location: Location(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.latitude))
                    await self.parent.vm.setPlace(place)
                }
            }
        }
 
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.canShowCallout = true
            return annotationView
        }
    }
}
