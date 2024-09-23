//
//  File.swift
//  
//
//  Created by Manikandan on 22/09/24.
//

import UIKit

public class RatingComponentViewModel : ObservableObject{
    
    var maxRating : Int = 5
    @Published var rating : Double
    var onImage : UIImage?
    var offImage : UIImage?
    var reviewCount : Int

    public init(rating : Double,onImage: UIImage?,offImage: UIImage?,reviewCount : Int){
        self.rating = rating
        self.onImage = onImage
        self.offImage = offImage
        self.reviewCount = reviewCount
    }

}
