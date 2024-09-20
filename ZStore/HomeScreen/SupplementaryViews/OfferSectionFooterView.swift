//
//  OfferSectionFooterView.swift
//  ZStore
//
//  Created by Manikandan on 20/09/24.
//

import UIKit
import DesignSystem

class OfferSectionFooterView : UICollectionReusableView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView(){
        let baseView = UIView()
        
        let icon = UIImage(named: "flash")
        let imageView = UIImageView(image: icon)

        baseView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
                
        let label = UILabel()
        label.text = "Offers Footer"
        label.font = .fontStyle(size: 18, weight: 600)
        label.textColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)
        
        baseView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(baseView).offset(10)
        }
        
        self.addSubview(baseView)
        
        baseView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
