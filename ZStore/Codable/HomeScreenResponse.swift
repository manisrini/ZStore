//
//  Products.swift
//  ZStore
//
//  Created by Manikandan on 20/09/24.
//

import Foundation

struct HomeScreenResponse : Codable{
    let category : [ProductCategory]?
    let card_offers : [CardOffer]?
    let products : [Product]?
}

struct ProductCategory : Codable{
    let id : String
    let name : String?
    let layout : String?
}

struct CardOffer : Codable{
    let id : String
    let percentage : Double?
    let offer_desc : String?
    let card_name : String?
    let max_discount : String?
    let image_url : String?
}

struct Product : Codable{
    let id : String
    let name : String?
    let rating : Double?
    let review_count : Int?
    let price : Double?
    let category_id : String?
    let card_offer_ids : [String]?
    let image_url : String?
    let description : String?
    let colors : [String]?
}
