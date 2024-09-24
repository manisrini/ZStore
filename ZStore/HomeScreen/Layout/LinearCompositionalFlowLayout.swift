//
//  LinearCompositionFlowLayout.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import Foundation
import UIKit

class LinearCompositionFlowLayout{
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        
        let productSectionGroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        productSectionGroupItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 0)
        let productSectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(250)), subitems: [productSectionGroupItem])
        let productSection = NSCollectionLayoutSection(group: productSectionGroup)
        

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0{
                return CompositionFlowLayout.getOfferLayout()
            }else {
                return productSection
            }
        }
        layout.configuration.interSectionSpacing = 5
        return layout
    }
}

class CompositionFlowLayout{
    
    static func getOfferLayout() -> NSCollectionLayoutSection{
        let offerSectionGroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        offerSectionGroupItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 2, trailing: 12)
        let section1Group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),heightDimension: .absolute(120)), subitems: [offerSectionGroupItem])
        let offerSection = NSCollectionLayoutSection(group: section1Group)
        let offerSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let offerSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        offerSection.boundarySupplementaryItems = [offerSectionHeader,offerSectionFooter]
        offerSection.orthogonalScrollingBehavior = .continuous
        
        return offerSection
    }
}
