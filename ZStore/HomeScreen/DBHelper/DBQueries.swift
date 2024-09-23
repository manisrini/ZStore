//
//  DBQueries.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//

import Foundation

class DBQueries {
    public static func filterBy(categoryId : String) -> NSPredicate
    {
        return NSPredicate(format: "category_id == %@",categoryId)
    }

    public static func filterBy(cardOfferId : String,categoryId : String) -> NSPredicate
    {
        return NSPredicate(format: "card_offers_ids CONTAINS %@ AND category_id == %@", cardOfferId,categoryId)

    }
    
}
