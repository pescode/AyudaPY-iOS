//
//  DefaultFontModifier.swift
//  AyudaPY
//
//  Created by Victor on 4/17/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct DefaultFontModifier: ViewModifier {
    var size:CGFloat = 22
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}
