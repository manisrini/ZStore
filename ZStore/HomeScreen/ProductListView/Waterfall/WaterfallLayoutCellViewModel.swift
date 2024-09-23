//
//  WaterfallLayoutCellViewModel.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import Foundation

class WaterfallLayoutCellViewModel
{
    let id : String
    let imageUrl : String
    let name : String
    let reviewCount : Int
    let rating : Double
    let price : Double
    let desc : String
    let isFavourite : Bool
    
    init(id : String,imageUrl : String,name: String,reviewCount : Int, rating: Double, price: Double, desc: String,isFavourite : Bool) {
        self.id = id
        self.name = name
        self.rating = rating
        self.reviewCount = reviewCount
        self.price = price
        self.desc = desc
        self.imageUrl = imageUrl
        self.isFavourite = isFavourite
    }
}
