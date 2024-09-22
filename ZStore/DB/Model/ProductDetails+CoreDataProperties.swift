//
//  ProductDetails+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension ProductDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDetails> {
        return NSFetchRequest<ProductDetails>(entityName: "ProductDetails")
    }

    @NSManaged public var card_offer_ids: Data?
    @NSManaged public var category_id: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var rating: Double
    @NSManaged public var review_count: Int64

}

extension ProductDetails : Identifiable {

}
