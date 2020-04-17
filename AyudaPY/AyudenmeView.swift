//
//  AyudenmeView.swift
//  AyudaPY
//
//  Created by Victor on 4/12/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct AyudenmeView: View {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @ObservedObject var userGeoInfo = UserGeoInfoViewModel()
    @State var startForm:Bool = false
    var body: some View {
        ZStack {
            if(!startForm)
            {
                VStack{
                    VStack(spacing:20) {
                        HStack {
                            Text("¿Necesitas ayuda?")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(Color("highlight"))
                            Spacer()
                        }
                        HStack {
                            Text("Aquí podrás publicar tu pedido para que la gente vea")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color("title"))
                            Spacer()
                        }
                        HStack {
                            Text("Esta es una plataforma ciudadana totalmente de la buena voluntad de la gente, no hay garantías de recibir ayuda sí o sí.")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color("normal"))
                            Spacer()
                        }
                        HStack {
                            Text("La información que cargues será 100% de acceso público")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color("normal"))
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        self.startForm.toggle()
                    })
                    {
                        Text("Entiendo, quiero continuar")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(maxWidth:.infinity)
                            .frame(height:50)
                            .background((startForm || userGeoInfo.defaultAddress.isEmpty) ? Color("light"):Color("button"))
                            .cornerRadius(32)
                    }.disabled((startForm || userGeoInfo.defaultAddress.isEmpty) ? true:false)
                        .padding(.top, 40)
                    Button(action: {
                        self.viewControllerHolder?.dismiss(animated: true)
                    })
                    {
                        Text("No, gracias")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color("title"))
                    }.disabled(startForm ? true:false)
                        .padding(.top, 32)
                    
                    
                    Spacer()
                    
                    Image("logoHeader")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 22)
                }
                .blur(radius: startForm ? 15:0)
                .opacity(startForm ? 0.5:1)
                .zIndex(startForm ? 0:1)
                .animation(.easeOut(duration: 0.8))
                .padding(32)
            }else{
                AyudenmeFormView(defaultAddress:userGeoInfo.defaultAddress)
                    .background(Color.white.opacity(1))
                    .opacity(startForm ? 1:0)
                    .zIndex(startForm ? 1:0)
                    .animation(.easeOut(duration: 0.8))
            }
            
        }
    }
}

struct AyudenmeView_Previews: PreviewProvider {
    static var previews: some View {
        AyudenmeView()
    }
}
