//
//  GeoInversaModel.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct GeoInversaModel: Codable {
    var data: Data?
}

extension GeoInversaModel{
    struct Data: Codable{
        var departamento: String?
        var distrito: String?
        var localidad: String?
        var direccion: String?
    }
}


