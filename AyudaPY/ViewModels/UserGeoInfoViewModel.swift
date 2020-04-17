//
//  DataStore.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

final class UserGeoInfoViewModel: ObservableObject {
    
    var userGeoInfo: GeoInversaModel?
    private var locationManager = CLLocationManager()
    @Published private(set) var defaultAddress: String = ""
    
    init()
    {
        getUserGeoInfo()
    }
    
    func getUserGeoInfo(){
        let latitude = locationManager.location?.latitude ?? 0
        let longitude = locationManager.location?.longitude ?? 0
        Api().getGeoInversa(lat: "\(latitude)", long: "\(longitude)"){ (geoInfo) in
            self.userGeoInfo = geoInfo
            self.defaultAddress = "\(geoInfo.data?.direccion ?? ""), \(geoInfo.data?.localidad ?? ""), \(geoInfo.data?.distrito ?? ""), \(geoInfo.data?.departamento ?? "")"
            print("Address updated \(self.defaultAddress)")
            
        }
    }
}

