//
//  array+ext.swift
//  ZStore
//
//  Created by Manikandan on 25/09/24.
//

import Foundation
import UIKit


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

extension UICollectionView
{
    
    public func setEmptyMessageText(_ message: String,textColor:UIColor)
    {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "ProximaNova-Regular", size: 16.0)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }

}
