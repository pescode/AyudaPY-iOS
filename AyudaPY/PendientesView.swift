//
//  PendientesView.swift
//  AyudaPY
//
//  Created by Victor on 4/10/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI
import UIKit
struct PendientesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    @EnvironmentObject var appStates : AppStore
    var helpItems:FetchedResults<HelpItem>
    @State var helpDetails:HelpRequestModel = HelpRequestModel()
    
    @State var isPresentingDetail = false
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.1)
            
            ZStack {
                Text("Mis Pendientes")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("highlight"))
                
                ZStack {
                    Image("iconPendientesChecked")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .padding(.trailing,20)
                }.frame(maxWidth:.infinity,alignment: .topTrailing)
            }
            
            List {
                ForEach(self.helpItems){ helpItem in
                    Button(action: {
                        
                        Api().getHelpRequest(with: helpItem.idPedido!.toUInt()!){ (result) in
                            self.helpDetails = result
                            self.isPresentingDetail.toggle()
                        }
 
                        
                    }){
                        HStack {
                            VStack {
                                Text("\(Utils().dateFormat(inFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ",outFormat: "dd", date: helpItem.date ?? ""))")
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                    .foregroundColor(Color("title"))
                                Text("\(Utils().dateFormat(inFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ",outFormat: "MMM", date: helpItem.date ?? "").uppercased())")
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundColor(Color("highlight"))
                            }
                            .padding(8)
                            
                            Color("title")
                                .frame(width: 1, height: 50)
                            
                            HStack{
                                VStack(alignment: .leading) {
                                    Text("\(helpItem.title ?? "")")
                                        .lineLimit(2)
                                        .modifier(DefaultFontModifier(size: 14))
                                        .foregroundColor(Color("title"))
                                    Text("\(helpItem.name ?? "")")
                                        .lineLimit(1)
                                        .modifier(DefaultFontModifier(size: 12))
                                        .foregroundColor(Color("light"))
                                        .padding(.top,6)
                                    Text("\(helpItem.desc ?? "")")
                                        .lineLimit(2)
                                        .modifier(DefaultFontModifier(size: 12))
                                        .foregroundColor(Color("light"))
                                    
                                }
                                Spacer()
                            }
                                
                            .padding(8)
                        }
                        .frame(maxWidth:.infinity)
                        .frame(height:100)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }.sheet(isPresented: self.$isPresentingDetail)
                    {
                        PendienteDetalleView(helpDetails: self.helpDetails)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                .onDelete{ indexSet in
                    for index in indexSet{
                        if !self.helpItems[index].isAttended
                        {
                            self.managedObjectContext.delete(self.helpItems[index])
                        }else{
                            self.managedObjectContext.performAndWait {
                                self.helpItems[index].isPendingList = false
                                do{
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error)
                                }
                            }
                        }
                    }
                }
            }.listSeparatorStyleNone()
            
        }
        .padding()
    }
}


public struct ListSeparatorStyleNoneModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
        }.onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
        }
    }
}

extension View {
    public func listSeparatorStyleNone() -> some View {
        modifier(ListSeparatorStyleNoneModifier())
    }
}

extension String {
    func toUInt() -> UInt? {
        let scanner = Scanner(string: self)
        var u: UInt64 = 0
        if scanner.scanUnsignedLongLong(&u)  && scanner.isAtEnd {
            return UInt(u)
        }
        return nil
    }
}
