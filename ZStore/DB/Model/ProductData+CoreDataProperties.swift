//
//  ProductData+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension ProductData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductData> {
        return NSFetchRequest<ProductData>(entityName: "ProductData")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int32
    @NSManaged public var colors: Data?
    @NSManaged public var card_offers_ids: Data?
    @NSManaged public var category_id: String?

}

extension ProductData : Identifiable {

}
