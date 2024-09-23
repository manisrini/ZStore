//
//  WaterfallLayoutCell.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import UIKit
import DesignSystem
import SwiftUI

class WaterfallLayoutCell: UICollectionViewCell {
    
    private var ratingView = RatingComponent(viewModel: RatingComponentViewModel(rating: 4.5, onImage: UIImage(named: "ratingFilled"), offImage: UIImage(named: "ratingNotFilled"),reviewCount: 5))
    
    
    private let imageContainerView : UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let favBtn : UIButton = {
        let favButton = UIButton(type: .system)
        favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) // SF Symbol heart icon
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGreen
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
        triangleView.clipsToBounds = true
        triangleView.layer.cornerRadius = 20
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        return triangleView
    }()
    
    private let addToFavButton: UIButton = {
        let favButton = UIButton(type: .system)
        let heartImage = UIImage(systemName: "heart") // Use SF Symbol for the heart icon
        favButton.setImage(heartImage, for: .normal)
        favButton.setTitle(" Add to Fav", for: .normal)
        favButton.addTarget(self, action: #selector(didTapFavButton), for: .touchUpInside)
        
        // Adjust the image and text placement
        favButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        favButton.tintColor = .darkGray
        favButton.setTitleColor(.darkGray, for: .normal)
        
        favButton.layer.borderColor = UIColor.lightGray.cgColor
        favButton.layer.borderWidth = 1
        favButton.layer.cornerRadius = 10
        
        favButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 10)
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
    
    @objc func didTapFavButton(){
        
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
            make.left.equalTo(contentView).offset(5)
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
            make.width.equalTo(140)
        }
    }
    
    func config(with product: WaterfallLayoutCellViewModel) {
        productImageView.loadImage(url: product.imageUrl)
        titleLabel.text = product.name
        priceLabel.text = "₹\(product.price)"
        self.ratingView.setRating(rating: product.rating,reviewCount: product.reviewCount)

    }
}


class TriangleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear // Transparent background for the view itself
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width, y: 0))  // Top right corner
        path.addLine(to: CGPoint(x: rect.width, y: rect.height)) // Bottom right corner
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom left corner
        path.close() // Connect back to the start
        
        UIColor.systemPink.setFill()
        path.fill()
        self.rotateTriangle(by: 3 * CGFloat.pi/2) // rotate by 270 degrees
    }
    
    func rotateTriangle(by angle: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
}
