//
//  File.swift
//  
//
//  Created by Manikandan on 23/09/24.
//

import UIKit
import SnapKit

public class ZChipView : UIView{
    
    let chipLbl : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let containerView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView(){
//        self.addSubview/*(containerView)*/
        self.addSubview(chipLbl)

//        containerView.snp.makeConstraints { make in
//            make.left.equalTo(self)
//            make.right.equalTo(self)
//            make.height.equalTo(30)
//        }
        
        chipLbl.snp.makeConstraints { make in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(5)
            make.centerY.equalTo(self)
        }
        chipLbl.font = .fontStyle(size: 13, weight: .medium)
        chipLbl.layer.cornerRadius = 13
        
        chipLbl.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(15)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
    }
    
    public func config(
        with text : String,
        height : CGFloat = 14,
        font : UIFont = .fontStyle(size: 13, weight: .medium),
        bgColor : UIColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Capsicum.rawValue),
        textColor : UIColor = .white
    ){
        self.chipLbl.text = text
        self.chipLbl.font = font
        self.chipLbl.textColor = textColor
        self.chipLbl.backgroundColor = bgColor
//        self.containerView.backgroundColor = bgColor
//        self.containerView.snp.makeConstraints { make in
//            make.height.equalTo(height)
//        }
    }

}
