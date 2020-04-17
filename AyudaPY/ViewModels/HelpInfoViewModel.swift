//
//  HelpInfoViewModel.swift
//  AyudaPY
//
//  Created by Victor on 4/15/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import Combine

class HelpInfoViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var name: String = ""
    @Published var phone: String = ""
    @Published var address: String = ""
    @Published var refs: String = ""
    @Published var defaultAddress: String = ""

    func setDefaultAddress(address:String)
    {
        self.defaultAddress = address
    }
    
}

