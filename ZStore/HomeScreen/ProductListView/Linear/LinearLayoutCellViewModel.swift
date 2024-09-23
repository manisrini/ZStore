//
//  LinearLayoutCellViewModel.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import Foundation

struct OfferPrice{
    let amountSaved : Int
    let offerPrice : Int
}

class LinearLayoutCellViewModel
{
    let id : String
    let imageUrl : String
    let name : String
    let reviewCount : Int
    let rating : Double
    let price : Double
    let desc : String
    let colors : [String]?
    let offer : OfferPrice?
    
    init(id : String,imageUrl : String,name: String,reviewCount : Int, rating: Double, price: Double, desc: String, colors: [String]?,offer : OfferPrice? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
        self.reviewCount = reviewCount
        self.price = price
        self.desc = desc
        self.colors = colors
        self.imageUrl = imageUrl
        self.offer = offer
    }
}
