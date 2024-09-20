//
//  Extensions.swift
//  ZStore
//
//  Created by Manikandan on 20/09/24.
//

import Foundation
import UIKit


var isNotchDisplay : Bool
{
    if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
}
