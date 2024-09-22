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
    @NSManaged public var review_count: Int64
    @NSManaged public var colors: Data?
    @NSManaged public var card_offers: CardOfferData?
    @NSManaged public var category: CategoryData?

}

extension ProductData : Identifiable {

}


extension ProductData {
    @objc(addCardOffersObject:)
    @NSManaged public func addToCardOffers(_ value: [CardOfferData])

    @objc(addCardOffers:)
    @NSManaged public func addToCardOffers(_ values: NSSet)

}
