//
//  LocationManager.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // Publish the user's location so subscribers can react to updates
    @Published var userLocation: CLLocation?
    @Published private(set) var userAuthorization: CLAuthorizationStatus?
    @Published var userAuthorizedGeo: Bool = false
    private let manager = CLLocationManager()

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.userAuthorization = status
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.userAuthorizedGeo = true
            self.manager.startUpdatingLocation()
        }else{
            self.userAuthorizedGeo = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}
