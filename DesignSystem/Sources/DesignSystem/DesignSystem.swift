// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public enum DSMColorTokens : String{
    
    case Arattai_Tangelo = "E6560F"
    case Secondary = "545454"
}


extension UIFont{
    public static func fontStyle(size : CGFloat,weight : Int) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
