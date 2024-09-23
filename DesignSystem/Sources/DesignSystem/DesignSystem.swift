// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public enum DSMColorTokens : String{
    
    case Arattai_Tangelo = "E6560F"
    case SecondaryGrey = "545454"
    case Blue = "226AB4"
    case Tertiary = "747474"
    case Quaternary = "989898"
    case LineGrey = "EFEFEF"
    case SeparatorGrey = "D8D8D8"
    case Capsicum = "158C5B"
}


extension UIFont{
    public static func fontStyle(size : CGFloat,weight : UIFont.Weight) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
