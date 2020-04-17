//
//  MenuView.swift
//  AyudaPY
//
//  Created by Victor on 4/12/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: HelpItem.getPendingHelpItems()) var helpItems:FetchedResults<HelpItem>
    
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @EnvironmentObject var appStates : AppStore
    
    @State var showInfoView = false
    @State var showPendientesView = false
    
    @Binding var showMenu:Bool
    
    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    self.showInfoView.toggle()
                }) {
                    Image("infoButton")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height:55)
                }.sheet(isPresented: $showInfoView){
                    InfoView()
                }
                    
                Text("INFO")
                    .font(.system(size: 10, weight: .regular, design: .default))
                    .foregroundColor(Color("button"))
                    
            }
            .frame(width:70)
            .padding(.leading,24)
            
            Spacer()
            
            VStack {
                Button(action: {
                    self.showPendientesView.toggle()
                }) {
                    Image("pendientesButton")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height:55)
                }.sheet(isPresented: $showPendientesView)
                {
                    PendientesView(helpItems: self.helpItems)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                        .environment(\.viewController, self.viewControllerHolder)
                        .environmentObject(self.appStates)
                }
                Text("PENDIENTES")
                    .font(.system(size: 10, weight: .regular, design: .default))
                    .foregroundColor(Color("button"))
                    
                    
            }
            .frame(width:70)
            .padding(.trailing,24)
        }
        .frame(maxWidth:showMenu ? 280:0)
        .frame(height:showMenu ? 90:0)
        .opacity(showMenu ? 1 : 0)
        .background(Color("menubg"))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        .padding(.horizontal, 12)
        .overlay(
            VStack {
                Image("addAyuda")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(x: showMenu ? 1:2, y: showMenu ? 1:0.2, anchor: .center)
                    .frame(width: 80,height:80)
                    .onTapGesture {
                        self.viewControllerHolder?.present(style: .fullScreen){
                            AyudenmeView()
                        }
                }
                
                Text("AYUDENME")
                    .font(.system(size: 10, weight: .bold, design: .default))
                    .foregroundColor(showMenu ? Color("highlight"):Color.clear)
            }
            .frame(width:100)
            .opacity(showMenu ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                
            .offset(y:-12)
        )
            .animation(.spring(response: 0.5, dampingFraction: showMenu ? 0.4:0.9, blendDuration: 0))
        
    }
}
