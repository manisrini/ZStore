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
        
        let section1GroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        section1GroupItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 2, trailing: 12)
        let section1Group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),heightDimension: .absolute(120)), subitems: [section1GroupItem])
        let offersSection = NSCollectionLayoutSection(group: section1Group)
        
        //Header
        let offersSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        //Footer
        let offersSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        offersSection.boundarySupplementaryItems = [offersSectionHeader,offersSectionFooter]
        offersSection.orthogonalScrollingBehavior = .continuous
        

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0{
                return offersSection
            }else{
                return WaterfallCompositionalFlowLayout.createWaterFallLayout(env: layoutEnv, items: items)
            }
        }
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
            enviroment: env, sectionIndex: 1
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
        let extraHeight : CGFloat = 20
        let totalHeight : CGFloat = imageContainerHeight + titleHeight + ratingViewHeight + priceDetailsView + descHeight + addTofavBtnHeight + 30
        
        return totalHeight
    }
}

