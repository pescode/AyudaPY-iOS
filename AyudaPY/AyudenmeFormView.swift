//
//  AyudenmeFormView.swift
//  AyudaPY
//
//  Created by Victor on 4/12/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import CoreLocation

struct AyudenmeFormView: View {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    @State private var currentForm = 0
    
    @ObservedObject var helpInfo = HelpInfoViewModel()
    
    @State var bottomState = CGSize.zero
    
    var defaultAddress:String
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.viewControllerHolder?.dismiss(animated: true)
                    }) {
                        Image("iconClose")
                            .renderingMode(.original)
                    }
                }
                Spacer()
            }
            
            FormInputView(currentForm:$currentForm, field: $helpInfo.title,
                          formTitle: "Título del pedido",
                          formDesc: "Descripción de qué estás necesitando",
                          formExample: "Ejemplo: Necesito de manera urgente víveres para mi familiar.",
                          formId: 0)
                .offset(x: 0, y: (currentForm == 0 ? 0 : -400))
                .opacity(currentForm == 0 ? 1 : 0)
                .blur(radius: currentForm == 0 ? 0 : 15)
                .animation(.easeOut(duration: 0.8))
            
            FormInputView(currentForm:$currentForm, field: $helpInfo.message,
                          formTitle: "Descripción del pedido",
                          formDesc: "Contanos detalladamente lo que necesitás, cuanto mejor cuentes tu situación, más probable será que quieran ayudarte.",
                          formExample: "Ejemplo: Por la situación actual estoy necesitando tapabocas y productos de limpieza, cualquier ayuda aunque sea mínima me servirá. Muchas gracias!.",
                          formId: 1)
                .offset(x: 0, y: (currentForm == 1 ? 0 : (currentForm > 1 ? -400 : 1000)))
                .opacity(currentForm == 1 ? 1 : 0)
                .blur(radius: currentForm == 1 ? 0 : 15)
                .animation(.easeOut(duration: 0.8))
            
            FormInputView(currentForm:$currentForm, field: $helpInfo.name,
                      formTitle: "Nombre y Apellido",
                      formDesc: "Por favor, ingrese su nombre y apellido.",
                      formExample: "Ejemplo: Juan Lopez.",
                      formId: 2)
            .offset(x: 0, y: (currentForm == 2 ? 0 : (currentForm > 2 ? -400 : 1000)))
            .opacity(currentForm == 2 ? 1 : 0)
            .blur(radius: currentForm == 2 ? 0 : 15)
            .animation(.easeOut(duration: 0.8))
            
            FormInputView(currentForm:$currentForm, field: $helpInfo.phone,
                      formTitle: "Télefono de contacto",
                      formDesc: "Ingrese un número teléfonico para que puedan contactar con usted.",
                      formExample: "Ejemplo: 0991123456",
                      formId: 3)
            .offset(x: 0, y: (currentForm == 3 ? 0 : (currentForm > 3 ? -400 : 1000)))
            .opacity(currentForm == 3 ? 1 : 0)
            .blur(radius: currentForm == 3 ? 0 : 15)
            .animation(.easeOut(duration: 0.8))
            
            FormInputView(currentForm:$currentForm, field: $helpInfo.address,
                      formTitle: "Dirección",
                      formDesc: "Ingrese su dirección, número de casa, barrio, ciudad o cualquier referencia útil para llegar.",
                      formExample: "Ejemplo: Francisco Lionel Bareiro 451, Fernando de la Mora, frente a la despensa San Cayetano.",
                      formId: 4)
            .offset(x: 0, y: (currentForm == 4 ? 0 : (currentForm > 4 ? -400 : 1000)))
            .opacity(currentForm == 4 ? 1 : 0)
            .blur(radius: currentForm == 4 ? 0 : 15)
            .animation(.easeOut(duration: 0.8))
                
            HStack {
                VStack(alignment: .leading) {
                    Color.clear
                        .frame(height:1)
                    Text("Confirmación")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color("title"))
                        .padding(.bottom,16)
                    
                    VStack {
                        HStack {
                            Text("Título del pedido")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("highlight"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        HStack {
                            Text(helpInfo.title)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("normal"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Descripción del pedido")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("highlight"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        HStack {
                            Text(helpInfo.message)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("normal"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Nombre y Apellido")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("highlight"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        HStack {
                            Text(helpInfo.name)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("normal"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        
                    }
                    
                    VStack {
                        HStack {
                            Text("Teléfono de contacto")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("highlight"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        HStack {
                            Text(helpInfo.phone)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("normal"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Dirección")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color("highlight"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                        HStack {
                            Text(helpInfo.address)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("normal"))
                                .padding(.vertical,4)
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        self.currentForm = 6
                    })
                    {
                        Text("PUBLICAR")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(width: 160)
                            .frame(height:50)
                            .background(Color("button"))
                            .cornerRadius(8)
                    }
                    .padding(.vertical, 50)
                    
                    Spacer()
                }
                Spacer()
            }
            .offset(x: 0, y: (currentForm == 5 ? 0 : (currentForm > 5 ? -400 : 1000)))
            .opacity(currentForm == 5 ? 1 : 0)
            .blur(radius: currentForm == 5 ? 0 : 15)
            .animation(.easeOut(duration: 0.8))
            
            if(currentForm == 6)
            {
                VStack(spacing:24) {
                    Image("logoHeader")
                    Text("Su pedido de ayuda fue registrado exitosamente")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("normal"))
                    Button(action: {
                        self.viewControllerHolder?.dismiss(animated: true)
                    })
                    {
                        Text("ACEPTAR")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height:50)
                            .background(Color("button"))
                            .cornerRadius(8)
                    }
                }
                .offset(x: 0, y: 0)
                .opacity(currentForm == 6 ? 1 : 0)
                .blur(radius: currentForm == 6 ? 0 : 15)
                .animation(.easeOut(duration: 0.8))
            }
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if(currentForm != 6){
                        Button(action:{
                            self.currentForm = self.currentForm - 1
                            if(self.currentForm < 0){
                                self.currentForm = 0
                            }
                        }) {
                        Image("upArrow")
                            .renderingMode(.template)
                            .foregroundColor(currentForm == 0 ? Color("light"):Color("title"))
                            .frame(width: 40, height: 40)
                        }
                        
                        Button(action:{
                            
                            if(self.currentForm == 0 && self.helpInfo.title.isEmpty){ return }
                            if(self.currentForm == 1 && self.helpInfo.message.isEmpty){ return }
                            if(self.currentForm == 2 && self.helpInfo.name.isEmpty){ return }
                            if(self.currentForm == 3 && self.helpInfo.phone.isEmpty){ return }
                            if(self.currentForm == 4 && self.helpInfo.address.isEmpty){ return }
                            
                            self.currentForm = self.currentForm + 1
                            if self.currentForm > 5
                            {
                                self.currentForm = 5
                            }
                        }) {
                            Image("downArrow")
                                .renderingMode(.template)
                                .foregroundColor(currentForm == 5 ? Color("light"):Color("title"))
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            self.helpInfo.address = self.defaultAddress
        }
        .padding()
    }
}

struct AyudenmeFormView_Previews: PreviewProvider {
    static var previews: some View {
        AyudenmeFormView(defaultAddress:"")
    }
}



struct FormInputView: View {
    @Binding var currentForm:Int
    @Binding var field : String
    var formTitle: String = ""
    var formDesc: String = ""
    var formExample: String = ""
    var formId: Int
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(formTitle)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color("highlight"))
            
            
            MultilineTextField("", text: $field, currentForm: $currentForm, formId: formId, keyboard: formId == 3 ? .decimalPad : .default, autoCapitalization: formId == 2 ? .words : .sentences, onCommit: {
                if(!self.field.isEmpty){
                    self.currentForm = self.currentForm + 1
                }
            })
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color("title"))
            
            
            
            Color("title")
                .frame(height:1.5)
            
            if(currentForm == 3 && !field.isEmpty)
            {
                HStack {
                    Spacer()
                    Button("LISTO") {
                        if(!self.field.isEmpty){
                            self.currentForm = self.currentForm + 1
                        }
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("highlight"))
                }
            }
            Text(formDesc)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color("normal"))
                .padding(.top,2)
            Text(formExample)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color("light"))
                .padding(.vertical,4)
            Spacer()
        }
        .background(Color.white)
        .padding(.top, 32)
        .onTapGesture {
            if(!self.field.isEmpty){
                UIApplication.shared.endEditing()
            }
        }
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
