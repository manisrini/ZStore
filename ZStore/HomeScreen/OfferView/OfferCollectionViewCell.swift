//
//  OfferCollectionViewCell.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import UIKit
import DesignSystem

class OfferCollectionViewCell : UICollectionViewCell
{
    static let identifier = Constants.OfferCell
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "HDFC Bank Credit card"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Flat 10% cashback on No Cost EMI and many more benefits!"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let cashbackLabel: UILabel = {
        let label = UILabel()
        label.text = "Upto ₹5000 Cashback"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let imageView: ZImageView = {
        let imageView = ZImageView()
        imageView.image = UIImage(named: "creditCardImage")
        imageView.layer.cornerRadius = 13
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        let textStackView = UIStackView(arrangedSubviews: [titleLabel,subTitleLabel,cashbackLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textStackView)
        self.contentView.addSubview(imageView)
        
        //Stack View constraints
        textStackView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.width.equalTo(220)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        //Image View constraints
        imageView.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        self.contentView.backgroundColor = .magenta
        self.contentView.layer.cornerRadius = 20
    }
    
    func config(viewModel : OfferCellViewModel){
        self.titleLabel.text = viewModel.titleText
        self.subTitleLabel.text = viewModel.subtitleText
        self.cashbackLabel.text = viewModel.cashbackText
        
        if let imageUrl = viewModel.imageUrl{
            self.imageView.loadImage(url: imageUrl)
        }
        
    }
}
