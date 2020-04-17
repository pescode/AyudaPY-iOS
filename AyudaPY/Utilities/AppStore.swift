//
//  Store.swift
//  AyudaPY
//
//  Created by Victor on 4/15/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import Combine

class AppStore: ObservableObject{
    @Published var helpRequestGeo:HelpRequestGeoModel = HelpRequestGeoModel(features: [])
    @Published var helpRequest:HelpRequestModel?
}

