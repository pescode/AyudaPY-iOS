//
//  InfoView.swift
//  AyudaPY
//
//  Created by Victor on 4/12/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Rectangle()
            .frame(width: 40, height: 5)
            .cornerRadius(3)
            .opacity(0.1)
            
            Image("logoHeader")
                .padding(.vertical,40)
            VStack(spacing:20) {
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://ayudapy.org/legal")!)
                }){
                    Text("Términos de Uso")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("button"))
                }
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://ayudapy.org/preguntas_frecuentes")!)
                }){
                    Text("Preguntas frecuentes")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("button"))
                }
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://ayudapy.org/")!)
                }){
                    Text("Visitar ayudapy.org")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("button"))
                }
            }
            .padding(.bottom,40)
            
            
            VStack(spacing:8) {
                Text("Esta APP fue desarrollada por")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("normal"))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://vcorva.com/")!)
                }){
                    Text("Victor Corvalan")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("button"))
                }
            }
            
            
            Spacer()
            
            VStack(spacing:12) {
                Text("El código fuente de esta aplicación está disponible bajo la licencia GPLv3")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color("light"))
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://github.com/pescode/AyudaPY-iOS")!)
                }){
                    Text("Revisá el código en GitHub")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("button"))
                }
            }
            
        }
        .padding()
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
