//
//  MapView.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import CoreLocation
import GoogleMaps

struct MapView: View {
    
    @ObservedObject var helpDetailsViewModel:HelpDetailsViewModel
    @Binding var showMenu:Bool
    
    var body: some View{
        GoogleMapView(helpDetailsViewModel:helpDetailsViewModel, showMenu: $showMenu)
    }
    
}

struct GoogleMapView: UIViewRepresentable{
    @FetchRequest(fetchRequest: HelpItem.getAllHelpItems()) var helpItemsDataBase:FetchedResults<HelpItem>
    @ObservedObject var helpDetailsViewModel:HelpDetailsViewModel
    
    @State var followUser:Bool = true
    var lm = CLLocationManager()
    
    @EnvironmentObject var appState : AppStore
    @Binding var showMenu:Bool
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.setMinZoom(15, maxZoom: 22)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isIndoorEnabled = false
        mapView.settings.compassButton = false
        mapView.delegate = context.coordinator
        if let myLocation = lm.location
        {
            mapView.animate(toLocation: myLocation.coordinate)
        }
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        mapView.settings.myLocationButton = !showMenu
        
        if followUser
        {
            if let myLocation = lm.location
            {
                mapView.animate(toLocation: myLocation.coordinate)
            }
        }
        
    }
    
    func makeCoordinator() -> GMapsCoordinator {
        Coordinator(self)
    }
}

class GMapsCoordinator: NSObject, GMSMapViewDelegate {
    var parent: GoogleMapView
    var isMakingCall: Bool = false
    var selectedMarkerID: UInt = 0
    init(_ parent: GoogleMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let helpItem = marker.userData as? HelpRequestGeoModel.Features else { return false }
        guard let helpID = helpItem.properties?.pk else { return false }
        self.parent.followUser = false
        self.parent.helpDetailsViewModel.get(helpID: helpID)
        selectedMarkerID = helpID
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: 18.5)
        CATransaction.commit()
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if(gesture){
            self.selectedMarkerID = 0
            self.parent.followUser = false
            self.parent.showMenu = false
            self.parent.helpDetailsViewModel.clear()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.parent.helpDetailsViewModel.clear()
           
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        let reducedSquareScreenSizeAmount = (mapView.layer.frame.width-(mapView.layer.frame.width*0.8))/2
        let centerY = mapView.layer.frame.height / 2
        
        let startY = centerY - ((mapView.layer.frame.width+reducedSquareScreenSizeAmount)/2)
        let endY = centerY + ((mapView.layer.frame.width+reducedSquareScreenSizeAmount)/2)
        
        //  Limitamos el area... hacemos que sea cuadrado y con márgenes horizontales
        let northEast = mapView.projection.coordinate(for: CGPoint(x: mapView.layer.frame.width - reducedSquareScreenSizeAmount, y: startY))
        let southWest = mapView.projection.coordinate(for: CGPoint(x: reducedSquareScreenSizeAmount, y: endY))
        
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: northEast.latitude, longitude: northEast.longitude))
        rect.add(CLLocationCoordinate2D(latitude: northEast.latitude, longitude: southWest.longitude))
        rect.add(CLLocationCoordinate2D(latitude: southWest.latitude, longitude: southWest.longitude))
        rect.add(CLLocationCoordinate2D(latitude: southWest.latitude, longitude: northEast.longitude))
        
        #if DEBUG
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 0.1)
        polygon.strokeWidth = 0
        //polygon.map = mapView
        #endif
        
        if self.isMakingCall
        {
            return
        }
        
        self.isMakingCall = true
        
        Api().getHelpRequestGeo(withBoundaryBox:  "\(northEast.longitude),\(northEast.latitude),\(southWest.longitude),\(southWest.latitude)"){ (result) in
            self.isMakingCall = false
            mapView.clear()
            
            result.features!.forEach{ item in
                
                guard let lat = item.geometry?.coordinates?[1] else { return }
                guard let lon = item.geometry?.coordinates?[0] else { return }
                
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let marker = GMSMarker(position: position)
                
                marker.icon = UIImage(named: self.checkIconType(id: "\(item.properties?.pk ?? UInt(0))"))
                marker.title = "¡Hola! Soy \(item.name())"
                marker.userData = item
                marker.map = mapView
                if(self.selectedMarkerID == item.properties?.pk)
                {
                    marker.map?.selectedMarker = marker
                }
            }
           
        }
    }
    
    func checkIconType(id:String) -> String
    {
        let find = parent.helpItemsDataBase.filter({$0.idPedido == id})
        guard let item = find.first else { return "pinGMAPS" }
        if item.isAttended { return "pinCheckedGMAPS" }
        if item.isPendingList { return "pinFavGMAPS" }
        return "pinGMAPS"
    }
}
