//
//  HelpRequestsGeoModel.swift
//  AyudaPY
//
//  Created by Victor on 4/13/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct HelpRequestGeoModel: Codable {
    var features: [Features]?
}

extension HelpRequestGeoModel{
    struct Features: Codable{
        var properties: Properties?
        var geometry: Geometry?
    }
}

extension HelpRequestGeoModel.Features{
    struct Properties: Codable{
        let pk: UInt
        var name: String = ""
    }
    
    struct Geometry: Codable{
        var coordinates:[Double]?
    }
}


extension HelpRequestGeoModel.Features{
    func name()->String
    {
        if let name = properties?.name.split(separator: " ").first?.capitalized{
            return name
        } else {
            return ""
            
        }
        
    }
}

