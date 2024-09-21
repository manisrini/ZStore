// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public enum DSMColorTokens : String{
    
    case Arattai_Tangelo = "E6560F"
    case Gray = "545454"
    case Blue = "226AB4"
}


extension UIFont{
    public static func fontStyle(size : CGFloat,weight : Int) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
