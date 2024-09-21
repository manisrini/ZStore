//
//  OfferSectionFooterView.swift
//  ZStore
//
//  Created by Manikandan on 20/09/24.
//

import UIKit
import DesignSystem

protocol OfferSectionFooterViewDelegate : AnyObject{
    func didTapButton()
}


class OfferSectionFooterView : UICollectionReusableView{
    
    var value : String = ""
    weak var delegate : OfferSectionFooterViewDelegate?
    
    private let leftLabel : UILabel = {
        let label = UILabel()
        label.text = "Applied:"
        label.textColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Gray.rawValue)
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let valueLabel : UILabel = {
        let label = UILabel()
        label.text = "HDFC Credit card"
        label.textColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Blue.rawValue)
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let closeButton : UIButton = {
        let button = UIButton()
        let btnImage = UIImage(named: "close")
        button.setImage(btnImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    @objc func didTapButton(){
        delegate?.didTapButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        
        closeButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        let leftLblContainerView = UIView()
        leftLblContainerView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(leftLblContainerView).offset(10)
            make.top.equalTo(leftLblContainerView)
            make.bottom.equalTo(leftLblContainerView)
            make.right.equalTo(leftLblContainerView)
        }
        
        
        let stackView = UIStackView(arrangedSubviews: [leftLblContainerView,valueLabel,closeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Blue.rawValue).cgColor
        stackView.layer.borderWidth = 1.5

        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(5)
            make.height.equalTo(35)
        }
    }
    
    func config(value : String){
        self.valueLabel.text = value
    }
}
