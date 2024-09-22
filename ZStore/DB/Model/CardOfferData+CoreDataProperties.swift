//
//  CardOfferData+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension CardOfferData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardOfferData> {
        return NSFetchRequest<CardOfferData>(entityName: "CardOfferData")
    }

    @NSManaged public var card_name: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var max_discount: String?
    @NSManaged public var offer_desc: String?
    @NSManaged public var percentage: Double
    @NSManaged public var products: ProductData?

}

extension CardOfferData : Identifiable {

}
