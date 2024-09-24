//
//  String_ext.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//

import Foundation
import UIKit

extension String
{
    func renderMarkDownText() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        
        let boldPattern = "\\*\\*(.*)\\*\\*"
        if let boldRegex = try? NSRegularExpression(pattern: boldPattern){
            let matches = boldRegex.matches(in: attributedString.string, range: NSRange(location: 0, length: attributedString.length))
            
            for match in matches{
                let boldTextRange = match.range(at: 1)
                let boldText = (attributedString.string as NSString).substring(with: boldTextRange)

                let boldAttributedString = NSAttributedString(string: boldText,attributes: [
                    .font : UIFont.systemFont(ofSize: 14,weight: .bold)
                ])

                attributedString.replaceCharacters(in: match.range,with: boldAttributedString)
            }
        }

        
        
        let linkPattern =  "\\[(.*)\\]\\((.*)\\)" //[Click here](link)
        
        if let linkRegex = try? NSRegularExpression(pattern: linkPattern){
            let matches = linkRegex.matches(in: attributedString.string, range:NSRange(location: 0, length: attributedString.length))
            for match in matches.reversed() {
                let linkTextRange = match.range(at: 1)  // displayed text
                let linkURLRange = match.range(at: 2)   //URL part
                
                let linkText = (attributedString.string as NSString).substring(with: linkTextRange)
                let linkURL = (attributedString.string as NSString as NSString).substring(with: linkURLRange)
                
                
                if let url = URL(string: linkURL){
                    let linkAttributedString = NSAttributedString(string: linkText,attributes: [
                        .link : url,
                        .foregroundColor : UIColor.systemBlue,
                        .underlineStyle : NSUnderlineStyle.single.rawValue,
                        .underlineColor : UIColor.systemBlue
                    ])
                    
                    attributedString.replaceCharacters(in: match.range, with: linkAttributedString)

                }
            }
            
            
        }
        return attributedString
    }
    
    func renderStrikeThrough() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    public func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }

}
