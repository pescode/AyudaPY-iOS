//
//  Api.swift
//  AyudaPY
//
//  Created by Victor on 4/11/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class Api {
    private var cancellable: AnyCancellable? = nil
    
    func getGeoInversa(lat:String, long:String,
                       completion: @escaping(GeoInversaModel) -> ()){
        guard let url = URL(string: "https://geo.cabu.dev/v1/geoinversa/\(lat)/\(long)") else { return }
        print(url.absoluteURL)
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            do{
                guard let data = data else { return }
                let payload = try JSONDecoder().decode(GeoInversaModel.self, from: data)
                DispatchQueue.main.async {
                    completion(payload)
                }
            }catch{
                print(error)
            }
            
        }
        .resume()
    }
    
    func getHelpRequestGeo(withBoundaryBox boundaryBox:String,
                        completion: @escaping(HelpRequestGeoModel) -> ()){
        let url = URL(string: "https://ayudapy.org/api/v1/helprequestsgeo/?in_bbox=\(boundaryBox)")
        print(url?.absoluteString ?? "")
        URLSession.shared.dataTask(with: url!){ (data, _, _) in
            
            guard let dataResponse = data else { return }
            let result = try! JSONDecoder().decode(HelpRequestGeoModel.self, from: dataResponse)
            
            DispatchQueue.main.async {
                completion(result)
            }
            
        }
        .resume()
        
    }
    
    func getHelpRequest(with id:UInt,
                        completion: @escaping(HelpRequestModel) ->())
    {
        let url = URL(string: "https://ayudapy.org/api/v1/helprequests/\(id)/")
        print(url!.absoluteURL)
        URLSession.shared.dataTask(with: url!){ (data, _, _) in
            
            guard let dataResponse = data else { return }
            let result = try! JSONDecoder().decode(HelpRequestModel.self, from: dataResponse)
            
            DispatchQueue.main.async {
                completion(result)
            }
            
        }
        .resume()
    }
    
    func getImage(url:String, completion: @escaping(UIImage?) ->())
    {
        
        guard let imgURL = URL(string: "https://ayudapy.org/media/pedidos/\(url)") else {
            return
        }
        print("Load img \(imgURL)")
        
        print("")
        URLSession.shared.dataTask(with: imgURL){ data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
}
