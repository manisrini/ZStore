//
//  WaterfallLayout.swift
//  ZStore
//
//  Created by Manikandan on 23/09/24.
//

import Foundation
import UIKit

class WaterfallCompositionalFlowLayout{
    
    static func createCompositionalLayout(showOffers : Bool = true) -> UICollectionViewCompositionalLayout{
        
        let section1GroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        section1GroupItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 2, trailing: 12)
        let section1Group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),heightDimension: .absolute(120)), subitems: [section1GroupItem])
        let offersSection = NSCollectionLayoutSection(group: section1Group)
        let section1Header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let section1Footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        offersSection.boundarySupplementaryItems = [section1Header,section1Footer]
        offersSection.orthogonalScrollingBehavior = .continuous
        
        
        let section2GroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        
        section2GroupItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let section2Group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [section2GroupItem,section2GroupItem])
        let listSection = NSCollectionLayoutSection(group: section2Group)
//        section2.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            switch sectionIndex{
            case 0:
                return offersSection
            case 1:
                return listSection
            default:
                return offersSection
            }
        }
        return layout
    }
}
