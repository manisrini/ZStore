//
//  AvailableColorViewModel.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import Foundation
import UIKit

enum Colors{
    static let black = UIColor.black
    static let white = UIColor.white
    static let gray = UIColor.gray
    static let silver = UIColor.green
    static let maroon = UIColor.magenta
    static let red = UIColor.red
    static let purple = UIColor.purple
    static let green = UIColor.green
    static let yellow = UIColor.yellow
    static let blue = UIColor.blue
    static let teal = UIColor.systemTeal
}

class AvailableColorsViewModel : ObservableObject{
    @Published var colors : [String] = []
    
    init(colors: [String]) {
        self.colors = colors
    }
    
    func getColor(_ color : String) -> UIColor{
        if color == "black"{
            return Colors.black
        }else if color == "white"{
            return Colors.white
        }else if color == "gray"{
            return Colors.gray
        }else if color == "silver"{
            return Colors.silver
        }else if color == "maroon"{
            return Colors.maroon
        }else if color == "red"{
            return Colors.red
        }else if color == "purple"{
            return Colors.purple
        }else if color == "green"{
            return Colors.green
        }else if color == "yellow"{
            return Colors.yellow
        }else if color == "blue"{
            return Colors.blue
        }else if color == "teal"{
            return Colors.teal
        }
        return Colors.green
    }

}
