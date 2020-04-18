//
//  HelpRequestsModel.swift
//  AyudaPY
//
//  Created by Victor on 4/11/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct HelpRequestModel: Codable {
    var id: UInt?
    var title: String?
    var message: String?
    var name: String?
    var phone: String?
    var address: String?
    var city: String?
    var location:Location?
    var added:String?
    var active:Bool?
}

extension HelpRequestModel{
    struct Location: Codable{
        let coordinates:[Double]?
    }
}

extension HelpRequestModel{
    func firstName() -> String
    {
        guard let fullName = name else { return "" }
        guard let firstName = fullName.split(separator: " ").first?.capitalized else { return "" }
        return firstName
    }
    
    func added(outFormat:String, inFormat:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        formatter.locale = Locale(identifier: "es")
        if let date = formatter.date(from: (added ?? "")) {
            formatter.dateFormat = outFormat
            let dateFormated = formatter.string(from: date)
            return dateFormated
        }
        return ""
    }
}
