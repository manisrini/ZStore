//
//  WaterfallLayout.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import Foundation
import UIKit
import DesignSystem

class WaterfallCompositionalFlowLayout{
    
    static func createCompositionalLayout(items : [ProductData]) -> UICollectionViewCompositionalLayout{
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0{
                return CompositionFlowLayout.getOfferLayout()
            }else{
                return WaterfallCompositionalFlowLayout.createWaterFallLayout(env: layoutEnv, items: items)
            }
        }
        layout.configuration.interSectionSpacing = 5
        return layout
    }
    
    static func createWaterFallLayout(env: NSCollectionLayoutEnvironment, items: [ProductData]) -> NSCollectionLayoutSection {
        
        let sectionHorizontalSpacing: CGFloat = 0
        
        let layout = WaterfallTrueCompositionalLayout.makeLayoutSection(
            config: .init(
                columnCount: 2,
                interItemSpacing: 5,
                sectionHorizontalSpacing: sectionHorizontalSpacing,
                itemCountProvider:  {
                    return items.count
                },
                itemHeightProvider: { index, itemWidth in
                    return WaterfallCompositionalFlowLayout.calculateHeight(product: items[index],availableWidth: itemWidth,index : index)
                }),
            environment: env, sectionIndex: 1
        )
        return layout
    }
    
    static func calculateHeight(product : ProductData,availableWidth : CGFloat,index : Int) -> CGFloat{
        let imageContainerHeight : CGFloat = 200
        let titleMaxHeight : CGFloat = 120
        let titleFont : UIFont = .fontStyle(size: 18,weight: .semibold)
        var titleHeight : CGFloat = product.name?.height(withConstrainedWidth: availableWidth, font: titleFont) ?? 0
        
        if titleHeight > titleMaxHeight{
            titleHeight = titleMaxHeight
        }

        let descHeight : CGFloat = 120
        
        let priceDetailsView : CGFloat = 30
        let ratingViewHeight : CGFloat = 30
        
        let addTofavBtnHeight : CGFloat = 36
        let totalHeight : CGFloat = imageContainerHeight + titleHeight + ratingViewHeight + priceDetailsView + descHeight + addTofavBtnHeight + 30
        
        return totalHeight
    }
}

