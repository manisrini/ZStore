//
//  LinearLayoutCell.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import UIKit
import DesignSystem
import SwiftUI
import SDWebImage

class LinearLayoutCell : UICollectionViewCell{
    
    static let identifier = CellIdentifiers.LinearLayoutCell
    private var colorsView = AvailableColorsView(viewModel: AvailableColorsViewModel(colors: []))
    private var ratingView = RatingComponent(viewModel: RatingComponentViewModel(rating: 4.5, onImage: UIImage(named: "ratingFilled"), offImage: UIImage(named: "ratingNotFilled"),reviewCount: 5))
    
    private let title : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .fontStyle(size: 18, weight: .semibold)
        return label
    }()
        
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
    
    private let descLbl : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = .fontStyle(size: 13, weight: .regular)
        label.textColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Tertiary.rawValue)
        return label
    }()
    
    private let productPreview: ZImageView = {
        let imageView = ZImageView()
        imageView.layer.cornerRadius = 13
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = Utils.hexStringToUIColor(hex: DSMColorTokens.LineGrey.rawValue).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let chipView : ZChipView = {
       let view = ZChipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(){
        
        let hostingColorsView = UIHostingController(rootView: colorsView)
        let hostingRatingView = UIHostingController(rootView: ratingView)

        let reviewHStackView = UIStackView(arrangedSubviews: [hostingRatingView.view])
        reviewHStackView.axis = .horizontal
        reviewHStackView.spacing = 4
        reviewHStackView.translatesAutoresizingMaskIntoConstraints = false
        
        reviewHStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        
        let containerPriceView = UIView()
        containerPriceView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(containerPriceView)
        containerPriceView.addSubview(currentPriceLbl)
        containerPriceView.addSubview(oldPriceLabel)
        containerPriceView.addSubview(chipView)
        
        containerPriceView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.left.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        currentPriceLbl.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }
        
        oldPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(currentPriceLbl.snp.right).offset(5)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }
        
        chipView.snp.makeConstraints { make in
            make.left.equalTo(oldPriceLabel.snp.right).offset(5)
            make.top.equalTo(containerPriceView).offset(5)
            make.centerY.equalTo(containerPriceView)
        }
        
        self.contentView.addSubview(productPreview)

        //Image View constraints
        productPreview.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }

//        self.contentView.addSubview(title)
//        
//        title.snp.makeConstraints { make in
//            make.top.equalTo(contentView)
//            make.left.equalTo(productPreview.snp.right).offset(15)
//            make.right.lessThanOrEqualTo(self.contentView).offset(-10)
//            make.height.greaterThanOrEqualTo(10)
//        }
//        
//        
//        self.contentView.addSubview(reviewHStackView)
//        
//        reviewHStackView.snp.makeConstraints { make in
//            make.top.equalTo(title.snp.bottom).offset(2)
//            make.left.equalTo(productPreview.snp.right).offset(15)
//            make.right.lessThanOrEqualTo(self.contentView).offset(-10)
//            make.height.equalTo(20)
//        }
//        
//        self.contentView.addSubview(priceHStackView)
//        
//        priceHStackView.snp.makeConstraints { make in
//            make.top.equalTo(reviewHStackView.snp.bottom).offset(2)
//            make.left.equalTo(productPreview.snp.right).offset(15)
//            make.right.lessThanOrEqualTo(self.contentView).offset(-10)
//            make.height.equalTo(25)
//        }
        
        let detailsVStackView = UIStackView(arrangedSubviews: [title,reviewHStackView,containerPriceView,descLbl,hostingColorsView.view])
        detailsVStackView.axis = .vertical
        detailsVStackView.spacing = 2
        detailsVStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Image View constraints
        productPreview.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }

        self.contentView.addSubview(detailsVStackView)
                
        //details view constraints
        detailsVStackView.snp.makeConstraints { make in
            make.left.equalTo(productPreview.snp.right).offset(15)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView)
//            make.height.equalTo(200)
        }
    }

    
    func config(with viewModel : LinearLayoutCellViewModel){
        self.title.text = viewModel.name
        
        if let cardOffer = viewModel.offer{
            self.currentPriceLbl.text = "₹\(cardOffer.offerPrice)"
            self.oldPriceLabel.attributedText = String(describing: viewModel.price).renderStrikeThrough()
            self.chipView.config(with: "\(cardOffer.amountSaved)")
            self.oldPriceLabel.isHidden = false
            self.chipView.isHidden = false
            
        }else{
            self.chipView.isHidden = true
            self.currentPriceLbl.text = "₹\(Utils.formatDecimal(viewModel.price))"
            self.oldPriceLabel.isHidden = true
        }
        
        self.ratingView.setRating(rating: viewModel.rating,reviewCount: viewModel.reviewCount)
        if let _colors = viewModel.colors{
            self.colorsView.setColors(colors: _colors)
        }
        self.productPreview.loadImage(url: viewModel.imageUrl)
        
        self.descLbl.attributedText = viewModel.desc.renderMarkDownText()

    }
    
    
}
