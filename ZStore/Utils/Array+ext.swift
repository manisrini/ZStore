//
//  array+ext.swift
//  ZStore
//
//  Created by Manikandan on 25/09/24.
//

import Foundation


extension Data{
    func toArray() -> [String]{
        do {
            let stringArray = try JSONDecoder().decode([String].self, from: self)
            return stringArray
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        return []
    }
}

extension Array {
    public func toData() -> Data? {
         do {
             let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
             return jsonData
         } catch {
             print(error.localizedDescription)
         }
         return nil
     }
}

