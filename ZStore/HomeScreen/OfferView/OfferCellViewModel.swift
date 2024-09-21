//
//  OfferCellViewModel.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import Foundation

class OfferCellViewModel
{
    let titleText : String
    let subtitleText : String
    let cashbackText : String
    let imageUrl : String?
    
    init(titleText: String, subtitleText: String, cashbackText: String,imageUrl : String?) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.cashbackText = cashbackText
        self.imageUrl = imageUrl
    }
}
