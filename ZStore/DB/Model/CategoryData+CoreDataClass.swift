//
//  CategoryData+CoreDataClass.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


public class CategoryData: NSManagedObject {
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init Called!!!!!")
    }
}
