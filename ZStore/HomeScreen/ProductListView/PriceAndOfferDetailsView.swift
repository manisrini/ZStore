//
//  PriceAndDetailsView.swift
//  ZStore
//
//  Created by Manikandan on 24/09/24.
//

import Foundation
import UIKit
import DesignSystem

class PriceAndOfferDetailsView : UIView{
    
    private let currentPriceLbl : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .fontStyle(size: 20, weight: .semibold)
        return label
    }()
    
    private let oldPriceLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let chipView : ZChipView = {
       let view = ZChipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(){
        let containerPriceView = UIView()
        containerPriceView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerPriceView)
        containerPriceView.addSubview(currentPriceLbl)
        containerPriceView.addSubview(oldPriceLabel)
        containerPriceView.addSubview(chipView)
        
        containerPriceView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(40)
        }
        
        currentPriceLbl.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }
        
        oldPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(currentPriceLbl.snp.right).offset(5)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }
        
        chipView.snp.makeConstraints { make in
            make.left.equalTo(oldPriceLabel.snp.right).offset(2)
            make.right.equalTo(containerPriceView.snp.right).offset(-2)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }

    }
    
    func config(price : Double,offerPrice: Int?,amountSaved : Int?,hideAmountSaved : Bool = false){
        if let _offerPrice = offerPrice{
            self.currentPriceLbl.text = "₹\(String(describing: _offerPrice))"
            self.oldPriceLabel.attributedText = String(describing: Utils.formatDecimal(price)).renderStrikeThrough()
            self.oldPriceLabel.isHidden = false

            if hideAmountSaved{
                self.chipView.isHidden = true
            }else{
                self.chipView.config(with: "Save ₹\(String(describing: amountSaved ?? 0))")
                self.chipView.isHidden = false
            }            
        }else{
            self.chipView.isHidden = true
            self.currentPriceLbl.text = "₹\(Utils.formatDecimal(price))"
            self.oldPriceLabel.isHidden = true
        }
        

    }

}
