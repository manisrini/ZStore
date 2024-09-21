//
//  LinearLayoutCellViewModel.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import Foundation

class LinearLayoutCellViewModel
{
    let imageUrl : String
    let name : String
    let reviewCount : Int
    let rating : Double
    let price : Double
    let desc : String
    let colors : [String]?
    
    init(imageUrl : String,name: String,reviewCount : Int, rating: Double, price: Double, desc: String, colors: [String]?) {
        self.name = name
        self.rating = rating
        self.reviewCount = reviewCount
        self.price = price
        self.desc = desc
        self.colors = colors
        self.imageUrl = imageUrl
    }
}
