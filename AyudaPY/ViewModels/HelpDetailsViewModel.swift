//
//  HelpDetailsViewModel.swift
//  AyudaPY
//
//  Created by Victor on 4/16/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

class HelpDetailsViewModel: ObservableObject {
    @Published var details:HelpRequestModel = HelpRequestModel()
    @Published private(set) var showDetails:Bool = false
    @State var show:Bool = false
}

extension HelpDetailsViewModel{
    func get(helpID:UInt){
        Api().getHelpRequest(with: helpID){ response in
            self.details = response
            self.showDetails = true
            self.show = true
        }
    }
    
    func clear(){
        self.showDetails = false
        self.show = false
        self.details = HelpRequestModel()
    }
}
