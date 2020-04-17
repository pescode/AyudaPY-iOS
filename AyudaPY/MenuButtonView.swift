//
//  MenuButtonView.swift
//  AyudaPY
//
//  Created by Victor on 4/12/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct MenuButtonView: View {
    var body: some View {
        VStack {
            Text("MOSTRAR MENU")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
            
        }
        .frame(width: 160, height: 30)
        .background(Color("highlight"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(width: 170, height: 38)
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding()
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView()
    }
}
