//
//  MapViewModel.swift
//  335Final
//
//  Created by Mathew MacMillan on 11/27/22.
//

import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate
{
    
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1, longitude: 1), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    @Published var flag = false
    
    func checkIfLocationServicesIsEnabled()
    {
        
        if(CLLocationManager.locationServicesEnabled())
        {
            
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        }
        else
        {
            
            print("show alert")
            
        }
        
    }
    
    func checkLocationAuthorization()
    {
        
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus
        {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("permission denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            flag = true
        @unknown default:
            break
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
