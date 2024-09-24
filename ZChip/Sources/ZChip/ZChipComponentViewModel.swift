// The Swift Programming Language

import Foundation
import UIKit

public struct Tag{
    public var id : String
    public var text : String
    public var isSelected : Bool
    
    public init(id : String,text: String,isSelected: Bool = false) {
        self.id = id
        self.text = text
        self.isSelected = isSelected
    }
}

public class ZChipComponentViewModel
{
    var tags : [Tag] = []
    var prevTagSelectedIndex : Int = 0

    public init(tags: [Tag] = []) {
        self.tags = tags
    }
        
    func createViewModel(index : Int) -> TagModel
    {
        let tag = self.tags[index]
        if tag.isSelected{
            return TagModel(
                text: tag.text,
                bgColor: CommonUtils.shared.hexStringToUIColorWithOpacity(hex: "E6560F", opacity: 0.5),
                textColor: CommonUtils.shared.hexStringToUIColor(hex: "E6560F"),
                borderColor: CommonUtils.shared.hexStringToUIColor(hex: "E6560F"))

        }else{
            return TagModel(
                text: tag.text,
                bgColor: CommonUtils.shared.hexStringToUIColor(hex: "ffffff"),
                textColor: CommonUtils.shared.hexStringToUIColor(hex: "545454"),
                borderColor: CommonUtils.shared.hexStringToUIColor(hex: "D8D8D8"))
        }
    }
    
    func getTagValue(index : Int) -> String{
        let tag = self.tags[index]
        return tag.text
    }
    
    func updateTags(_ selectedIndex : Int){
        for index in 0 ..< tags.count {
            if index == selectedIndex{
                self.tags[index].isSelected = true
            }else{
                self.tags[index].isSelected = false
            }
        }
    }
}
