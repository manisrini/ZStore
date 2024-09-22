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
        return NSPredicate(format: "id == %@",categoryId)
    }
    
    public static func filterBy(ids : [String]) -> NSPredicate
    {
        return NSPredicate(format: "id IN %@", ids)

    }
    
}
