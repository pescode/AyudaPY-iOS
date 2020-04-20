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
    @Published var pic:UIImage?
}

extension HelpDetailsViewModel{
    func get(helpID:UInt){
        Api().getHelpRequest(with: helpID){ response in
            self.details = response
            
            guard let picURL = response.picture else {
                self.showDetails = true
                self.show = true
                return
            }
            
            let finalURL = "\(picURL.fileName())_th.\(picURL.fileExtension())"
            
            print("Final URL: \(finalURL)")
            Api().getImage(url: finalURL){ responsePic in
                if let pic = responsePic
                {
                    self.pic = pic
                }
                self.showDetails = true
                self.show = true
            }
            
            
        }
    }
    
    func clear(){
        self.pic = nil
        self.showDetails = false
        self.show = false
        self.details = HelpRequestModel()
    }
}
