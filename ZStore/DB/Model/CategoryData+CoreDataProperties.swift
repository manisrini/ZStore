//
//  CategoryData+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension CategoryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryData> {
        return NSFetchRequest<CategoryData>(entityName: "CategoryData")
    }

    @NSManaged public var id: String?
    @NSManaged public var layout: String?
    @NSManaged public var name: String?
    @NSManaged public var products: ProductData?

}

extension CategoryData : Identifiable {

}
