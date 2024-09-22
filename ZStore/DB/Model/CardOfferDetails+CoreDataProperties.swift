//
//  CardOfferDetails+CoreDataProperties.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//
//

import Foundation
import CoreData


extension CardOfferDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardOfferDetails> {
        return NSFetchRequest<CardOfferDetails>(entityName: "CardOfferDetails")
    }

    @NSManaged public var card_name: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var max_discount: String?
    @NSManaged public var offer_desc: String?
    @NSManaged public var percentage: Double

}

extension CardOfferDetails : Identifiable {

}
