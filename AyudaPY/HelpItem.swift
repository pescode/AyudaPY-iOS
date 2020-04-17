//
//  HelpItem.swift
//  AyudaPY
//
//  Created by Victor on 4/14/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import Foundation
import CoreData

public class HelpItem:NSManagedObject, Identifiable{
    @NSManaged public var date:String?
    @NSManaged public var title:String?
    @NSManaged public var name:String?
    @NSManaged public var desc:String?
    @NSManaged public var idPedido:String?
    @NSManaged public var isAttended:Bool
    @NSManaged public var isPendingList:Bool
}

extension HelpItem{
    static func getAllHelpItems() -> NSFetchRequest<HelpItem>{
        
        let request:NSFetchRequest<HelpItem> = HelpItem.fetchRequest() as! NSFetchRequest<HelpItem>
        
        let sortDescriptor = NSSortDescriptor(key: "idPedido", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    static func getPendingHelpItems() -> NSFetchRequest<HelpItem>{
        let request:NSFetchRequest<HelpItem> = HelpItem.fetchRequest() as! NSFetchRequest<HelpItem>
        
        let sortDescriptor = NSSortDescriptor(key: "idPedido", ascending: true)
        let predicator = NSPredicate(format: "isPendingList == %@", NSNumber(value: true))
        request.predicate = predicator
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
