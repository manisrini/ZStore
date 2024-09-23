//
//  WaterfallLayoutCell.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import UIKit
import DesignSystem
import SwiftUI

protocol WaterfallLayoutCellDelegate : AnyObject{
    func didTapAddToFavButton(productId  : String)
    func didTapFavButton(productId  : String)
}


class WaterfallLayoutCell: UICollectionViewCell {
    
    weak var delegate : WaterfallLayoutCellDelegate?
    var viewModel : WaterfallLayoutCellViewModel?
    
    private var ratingView = RatingComponent(viewModel: RatingComponentViewModel(rating: 4.5, onImage: UIImage(named: "ratingFilled"), offImage: UIImage(named: "ratingNotFilled"),reviewCount: 5))
    
    
    private let imageContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let favBtn : UIButton = {
        let favButton = UIButton(type: .system)
        favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favButton.addTarget(self, action: #selector(didTapFavButton), for: .touchUpInside)
        favButton.tintColor = .white
        favButton.layer.cornerRadius = 25 // Circular shape
        favButton.translatesAutoresizingMaskIntoConstraints = false
        return favButton
    }()
    
    private let productImageView: ZImageView = {
        let imageView = ZImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontStyle(size: 18,weight: .semibold)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .fontStyle(size: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let triangleView : TriangleView = {
        let triangleView = TriangleView()
        triangleView.rotateTriangle(by: 3 * CGFloat.pi/2) //270 degrees
        triangleView.clipsToBounds = true
        triangleView.layer.cornerRadius = 20
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        return triangleView
    }()
    
    private let addToFavButton: UIButton = {
        let favButton = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart")
        favButton.setImage(heartImage, for: .normal)
        favButton.setTitle(" Add to Fav", for: .normal)
        favButton.addTarget(self, action: #selector(didTapAddToFavButton), for: .touchUpInside)
        
        // Adjust the image and text placement
        favButton.titleLabel?.font = .fontStyle(size: 13, weight: .semibold)
        favButton.tintColor = Utils.hexStringToUIColor(hex: DSMColorTokens.SecondaryGrey.rawValue)
        favButton.setTitleColor(Utils.hexStringToUIColor(hex: DSMColorTokens.SecondaryGrey.rawValue), for: .normal)
        
        favButton.layer.borderColor = Utils.hexStringToUIColor(hex: DSMColorTokens.SeparatorGrey.rawValue).cgColor
        favButton.layer.borderWidth = 1
        favButton.layer.cornerRadius = 10
        
        favButton.translatesAutoresizingMaskIntoConstraints = false
        return favButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupViews() {
        let hostingRatingView = UIHostingController(rootView: ratingView)

        imageContainerView.addSubview(productImageView)
        imageContainerView.addSubview(triangleView)
        imageContainerView.addSubview(favBtn)
        contentView.addSubview(imageContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(hostingRatingView.view)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descLbl)
        contentView.addSubview(addToFavButton)
        
        contentView.layer.borderColor = Utils.hexStringToUIColor(hex: DSMColorTokens.LineGrey.rawValue).cgColor
        contentView.layer.borderWidth = 3
        contentView.layer.cornerRadius = 20
        // Add constraints
        
        imageContainerView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
        }

        productImageView.snp.makeConstraints { make in
            make.left.equalTo(imageContainerView)
            make.right.equalTo(imageContainerView)
            make.top.equalTo(imageContainerView)
            make.bottom.equalTo(imageContainerView)
        }
        
        favBtn.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView)
            make.trailing.equalTo(imageContainerView)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        triangleView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView)
            make.trailing.equalTo(imageContainerView)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-5)
            make.top.equalTo(productImageView.snp.bottom).offset(10)
        }
        
        hostingRatingView.view.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(5)
            make.top.equalTo(hostingRatingView.view.snp.bottom).offset(10)
        }
        
        descLbl.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(5)
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
        }
        
        addToFavButton.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(descLbl.snp.bottom).offset(10)
            make.height.equalTo(36)
            make.width.equalTo(110)
        }
    }
    
    @objc func didTapAddToFavButton(){
        if let _vm = viewModel{
            self.updateFavoritesWithAnimations(isFavourite: true)
            delegate?.didTapAddToFavButton(productId: _vm.id)
        }
    }
    
    @objc func didTapFavButton(){
        if let _vm = viewModel{
            self.updateFavoritesWithAnimations(isFavourite: false)
            delegate?.didTapFavButton(productId: _vm.id)
        }
    }
    
    private func updateFavoritesWithAnimations(isFavourite : Bool){
        if isFavourite{
            
            UIView.animate(withDuration: 0.3) {
                self.addToFavButton.alpha = 0
            }completion: { _ in
                self.addToFavButton.isHidden  = true
                self.addToFavButton.alpha = 1
            }
            
            self.favBtn.isHidden = false
            self.triangleView.isHidden = false
            
            self.favBtn.alpha = 0
            self.triangleView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.favBtn.alpha = 1
                self.triangleView.alpha = 1
            }

        }else{
            
            UIView.animate(withDuration: 0.3) {
                self.favBtn.alpha = 0
                self.triangleView.alpha = 0
            }completion: { _ in
                self.favBtn.isHidden = true
                self.triangleView.isHidden = true
                self.favBtn.alpha = 1
                self.triangleView.alpha = 1
            }

            self.addToFavButton.isHidden  = false
            self.addToFavButton.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.addToFavButton.alpha = 1
            }

        }
    }
    
    private func updateFavorites(isFavourite : Bool){
        if isFavourite{
            self.addToFavButton.isHidden  = true
            self.favBtn.isHidden = false
            self.triangleView.isHidden = false
        }else{
            self.favBtn.isHidden = true
            self.triangleView.isHidden = true
            self.addToFavButton.isHidden  = false
        }
        
    }
    
    func config(with product: WaterfallLayoutCellViewModel) {
        self.viewModel = product
        productImageView.loadImage(url: product.imageUrl)
        titleLabel.text = product.name
        priceLabel.text = "₹\(product.price)"
        descLbl.attributedText = product.desc.renderMarkDownText()
        self.ratingView.setRating(rating: product.rating,reviewCount: product.reviewCount)

        self.updateFavorites(isFavourite: product.isFavourite)
    }
}

