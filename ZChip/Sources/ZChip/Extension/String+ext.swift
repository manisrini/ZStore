//
//  File 2.swift
//  
//
//  Created by Manikandan on 20/09/24.
//

import Foundation

extension String{
    public func isWhiteSpace() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
