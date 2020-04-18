//
//  LocationManager.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // Publish the user's location so subscribers can react to updates
    @Published var userLocation: CLLocation? {
        willSet{ objectWillChange.send() }
    }
    @Published var userAuthorization: CLAuthorizationStatus?{
        willSet { objectWillChange.send() }
    }
    @Published var userAuthorizedGeo: Bool = false {
        willSet{ objectWillChange.send() }
    }
    private let manager = CLLocationManager()

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
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
            self.manager.requestWhenInUseAuthorization()
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
