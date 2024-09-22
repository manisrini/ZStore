//
//  CategoryDetails+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension CategoryDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryDetails> {
        return NSFetchRequest<CategoryDetails>(entityName: "CategoryDetails")
    }

    @NSManaged public var id: String?
    @NSManaged public var layout: String?
    @NSManaged public var name: String?

}

extension CategoryDetails : Identifiable {

}
