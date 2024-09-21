//
//  TagCell.swift
//  
//
//  Created by Manikandan on 20/09/24.
//

import UIKit

struct TagModel{
    var text : String
    var bgColor : UIColor = CommonUtils.shared.hexStringToUIColor(hex: "F5F5F5")
    var textColor : UIColor = CommonUtils.shared.hexStringToUIColor(hex: "283648")
    var borderColor : UIColor = CommonUtils.shared.hexStringToUIColor(hex: "DBDBDB")
}


class TagCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(model : TagModel){
        self.textLbl.text = model.text
        self.textLbl.textColor = model.textColor
        self.containerView.backgroundColor = model.bgColor
        self.containerView.borderColor = model.borderColor
        self.containerView.borderWidth = 1.5
        self.containerView.cornerRadius = 15
    }
    
}
