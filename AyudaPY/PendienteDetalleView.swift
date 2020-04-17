//
//  PendienteDetalleView.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import SwiftUI

struct PendienteDetalleView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: HelpItem.getAllHelpItems()) var helpItems:FetchedResults<HelpItem>
    
    
    @State private var showingCallActionSheet = false
    @State private var showingMapsActionSheet = false
    @State private var showingShareSheet = false
    
    @ObservedObject var helpDetails:HelpDetailsViewModel
    
    var body: some View {
        VStack{
            VStack {
                Rectangle()
                    .frame(width: 40, height: 5)
                    .cornerRadius(6)
                    .opacity(0.1)
            }
            .frame(height:40)
            
            ScrollView {
                VStack {
                    VStack {
                        
                        Text("Publicado el \(helpDetails.details.added(outFormat: "dd 'de' MMMM 'de' YYYY 'a las' HH:MM"))")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(Color("normal"))
                        
                        Group {
                            HStack {
                                Text(helpDetails.details.title ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color("highlight"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Text(helpDetails.details.message ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Color("normal"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Text("Dirección")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(Color("subtitle"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Text(helpDetails.details.address ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Color("normal"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Button(action: {
                                    self.showingMapsActionSheet = true
                                }){
                                    Text("Cómo llegar")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                        .foregroundColor(Color.white)
                                }
                                .actionSheet(isPresented: $showingMapsActionSheet){
                                    ActionSheet(
                                        title: Text("Seleccione una aplicación"),
                                        message: Text("\(helpDetails.details.address ?? "")"),
                                        buttons: [
                                            .default(Text("Apple Maps"),action: {
                                                let lat = self.helpDetails.details.location?.coordinates?[1] ?? 0
                                                let lon = self.helpDetails.details.location?.coordinates?[0] ?? 0
                                                let url:NSURL = URL(string: "maps://?daddr=\(lat),\(lon)")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("Waze"),action: {
                                                let lat = self.helpDetails.details.location?.coordinates?[1] ?? 0
                                                let lon = self.helpDetails.details.location?.coordinates?[0] ?? 0
                                                let url:NSURL = URL(string: "waze://?ll=\(lat),\(lon)&navigate=false")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("Google Maps"),action: {
                                                let lat = self.helpDetails.details.location?.coordinates?[1] ?? 0
                                                let lon = self.helpDetails.details.location?.coordinates?[0] ?? 0
                                                
                                                let url:NSURL = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)&directionsmode=driving")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("Cancelar"))
                                    ])
                                }
                                .frame(maxWidth:.infinity)
                                .frame(height:50)
                                .background(Color("button"))
                                .cornerRadius(8)
                            }
                            .padding(.top,16)
                        }
                        
                        VStack {
                            HStack {
                                Text("Contacto")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(Color("subtitle"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Text(helpDetails.details.name?.capitalized ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Color("normal"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Button(action: {
                                    self.showingCallActionSheet = true
                                    
                                }){
                                    Text(helpDetails.details.phone ?? "")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                        .foregroundColor(Color.white)
                                }
                                .actionSheet(isPresented: $showingCallActionSheet){
                                    ActionSheet(
                                        title: Text("Contactar con \(self.helpDetails.details.name ?? "" )"),
                                        message: Text("Seleccione una opción"),
                                        buttons: [
                                            .default(Text("Llamar"),action: {
                                                let url:NSURL = URL(string: "tel://\(self.helpDetails.details.phone ?? "")")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("Enviar un SMS"),action: {
                                                let url:NSURL = URL(string: "sms:\(self.helpDetails.details.phone ?? "")")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("WhatsApp"),action: {
                                                let name = self.helpDetails.details.name?.capitalized ?? ""
                                                let title = self.helpDetails.details.title ?? ""
                                                let mensaje = "Hola \(name) te escribo por el pedido que hiciste \(title) https://ayudapy.org/pedidos/\(self.helpDetails.details.id ?? 0).".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                                                let url:NSURL = URL(string: "whatsapp://send?phone=595\(self.helpDetails.details.phone ?? "")&text=\(mensaje ?? "")")! as NSURL
                                                UIApplication.shared.open(url as URL)
                                            }),
                                            .default(Text("Cancelar"))
                                    ])
                                }
                                .frame(maxWidth:.infinity)
                                .frame(height:50)
                                .background(Color("button"))
                                .cornerRadius(8)
                            }
                            .padding(.top,16)
                        }
                        
                        VStack {
                            HStack {
                                Text("Compartir")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(Color("subtitle"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Text("Utiliza esta opción para compartir en tus redes sociales este pedido de ayuda para que pueda llega a la persona que lo necesita.")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(Color("normal"))
                                Spacer()
                            }
                            .padding(.top,16)
                            HStack {
                                Button(action: {
                                    
                                    self.showingShareSheet = true
                                    
                                    
                                }){
                                    Text("Compartir")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                        .foregroundColor(Color.white)
                                }.sheet(isPresented: $showingShareSheet){
                                    ShareSheet(activityItems: [
                                        "\(self.helpDetails.details.name!.capitalized) necesita de nuestra ayuda! #ayudapy #ios",
                                        URL(string: "https://ayudapy.org/pedidos/\(self.helpDetails.details.id ?? 0)")!])
                                    
                                }
                                .frame(maxWidth:.infinity)
                                .frame(height:50)
                                .background(Color("button"))
                                .cornerRadius(8)
                            }
                            .padding(.top,16)
                        }
                        
                        VStack {
                            
                            HStack {
                                VStack(alignment: .center) {
                                    Button(action: {
                                        if let helpItem = self.checkIfSavedHelpItem()
                                        {
                                            self.managedObjectContext.performAndWait {
                                                helpItem.isPendingList = !helpItem.isPendingList
                                                do{
                                                    try self.managedObjectContext.save()
                                                }catch{
                                                    print(error)
                                                }
                                            }
                                        }else{
                                            self.saveHelpItem(isPendingList: true, isAttendeded: false)
                                        }
                                        
                                        
                                    }){
                                        Image(pendientesIcon)
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40, alignment: .center)
                                    }
                                    
                                    VStack {
                                        Text(pendientesText)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 12, weight: .regular, design: .default))
                                            .foregroundColor(Color("normal"))
                                        
                                        Spacer()
                                    }.frame(width: 120, height: 40, alignment: .center)
                                }
                                .frame(width:110)
                                
                                
                                VStack(alignment: .center) {
                                    Button(action: {
                                        if let helpItem = self.checkIfSavedHelpItem()
                                        {
                                            self.managedObjectContext.performAndWait {
                                                helpItem.isAttended = !helpItem.isAttended
                                                do{
                                                    try self.managedObjectContext.save()
                                                }catch{
                                                    print(error)
                                                }
                                            }
                                        }else{
                                            self.saveHelpItem(isPendingList: false, isAttendeded: true)
                                        }
                                    }){
                                        Image(attendedIcon)
                                            .renderingMode(.original)
                                            .frame(width: 40, height: 40, alignment: .center)
                                    }
                                    
                                    VStack {
                                        Text(attendedText)
                                            .font(.system(size: 12, weight: .regular, design: .default))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color("normal"))
                                        
                                        Spacer()
                                    }.frame(width: 120, height: 40, alignment: .center)
                                }
                                .frame(width:110)
                                
                            }
                            .padding(.top,32)
                            
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal,32)
            }
        }
        
        
        
    }
    
    func saveHelpItem(isPendingList:Bool = false, isAttendeded:Bool = false)
    {
        let helpItem = HelpItem(context: self.managedObjectContext)
        helpItem.date = self.helpDetails.details.added
        helpItem.name = self.helpDetails.details.name?.capitalized ?? ""
        helpItem.desc = self.helpDetails.details.address ?? ""
        helpItem.title = self.helpDetails.details.title ?? ""
        helpItem.idPedido = "\(self.helpDetails.details.id ?? 0)"
        helpItem.isPendingList = isPendingList
        helpItem.isAttended = isAttendeded
        do{
            try self.managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    func checkIfSavedHelpItem() -> HelpItem?
    {
        let id = "\(helpDetails.details.id ?? 0)"
        let find = helpItems.filter({$0.idPedido == id})
         
        guard let item = find.first else { return nil }
        return item
    }
    
    var pendientesIcon : String {
        guard let item = checkIfSavedHelpItem(), item.isPendingList else { return "iconPendientesUnchecked" }
        return "iconPendientesChecked"
    }
    
    var pendientesText : String {
        guard let item = checkIfSavedHelpItem(), item.isPendingList else { return "Agregar a Mis pendientes" }
        return "Quitar de Mis pendientes"
    }
    
    var attendedText : String {
        guard let item = checkIfSavedHelpItem(), item.isAttended else { return "Marcar como listo" }
        return "Desmarcar como listo"
    }
    
    var attendedIcon : String {
        guard let item = checkIfSavedHelpItem(), item.isAttended else { return "iconListoUnchecked" }
        return "iconListoChecked"
    }
    
    
}
