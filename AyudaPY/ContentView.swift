//
//  ContentView.swift
//  AyudaPY
//
//  Created by Victor on 4/9/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI


import GooglePlaces
import CoreLocation
import Foundation

struct ContentView: View {
    @EnvironmentObject var appStore : AppStore
    @State var bottomState = CGSize.zero
    @ObservedObject var locationManager = LocationManager()
    
    @State var showDetailsFull = false
    @State var showMenu = true
    
    @ObservedObject var helpDetailsViewModel = HelpDetailsViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("logoHeader")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .offset(y:-25)
                }
                .padding()
                .frame(maxWidth:.infinity)
                .frame(height: 100)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))]), startPoint: .top, endPoint: .bottom))
                Spacer()
            }
            
            VStack {
                Spacer()
                MenuView(showMenu: $showMenu)
                    .onTapGesture {
                        self.showMenu = false
                }
            }.padding(.bottom,32)
            
            VStack {
                Spacer()
                MenuButtonView()
                    .opacity(showMenu ? 0 : 1)
                    .blur(radius: showMenu ? 10:0)
                    .scaleEffect(x: showMenu ? 0:1, y: showMenu ? 1:1, anchor: .center)
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(showMenu ? 0:0.2))
                    .onTapGesture {
                        self.showMenu = true
                }
                
            }.padding(.bottom,32)
            
            if(locationManager.userAuthorizedGeo)
            {
                MapView(helpDetailsViewModel: helpDetailsViewModel, showMenu: $showMenu, locationManager: locationManager)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxHeight:.infinity)
                    .zIndex(-1)
            }else{
                VStack(alignment: .center, spacing: 20){
                    Text("AyudaPY necesita acceso a tu ubicación")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .foregroundColor(Color("normal"))
                    Text("Puedes modificar los permisos en Ajustes > Privacidad > Localización")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("light"))
                        .font(.system(size: 14))
                }
                .padding()
            }
            
            AyudaDetalleView(helpDetailsViewModel:helpDetailsViewModel)
                .offset(x: 0, y: helpDetailsViewModel.showDetails ? (UIScreen.main.bounds.size.height*0.52) : 1000)
                .offset(y:bottomState.height)
                .animation(.timingCurve(0.2, 0.80, 0.2, 1, duration: 0.4))
                .gesture(
                    DragGesture().onChanged{ value in
                        self.bottomState = value.translation
                        if self.showDetailsFull{
                            self.bottomState.height += -(UIScreen.main.bounds.size.height*0.52)
                        }
                        if self.bottomState.height < -(UIScreen.main.bounds.size.height*0.52){
                            self.bottomState.height = -(UIScreen.main.bounds.size.height*0.52)
                        }
                    }
                    .onEnded{ value in
                        if self.bottomState.height > 50{
                            self.showMenu = true
                            self.helpDetailsViewModel.clear()
                        }
                        if (self.bottomState.height < -100 && !self.showDetailsFull) || (self.bottomState.height < -250 && self.showDetailsFull){
                            self.bottomState.height = -(UIScreen.main.bounds.size.height*0.52)
                            self.showDetailsFull = true
                        }else{
                            self.bottomState = .zero
                            self.showDetailsFull = false
                        }
                    }
            )
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
