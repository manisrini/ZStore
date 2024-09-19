//
//  ViewController.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import UIKit
import SnapKit

class HomeScreenVC: UIViewController {
    
    var viewModel = HomeScreenViewModel()
    
    private var filterView : FilterView?
    
    private let storeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        return cv
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavStyles()
        self.setupFilterView()
        self.setupCollectionView()
        self.fetch()
    }
    
    private func setupFilterView(){
//        let filterView = FilterView()
//        self.filterView = filterView
//        filterView.backgroundColor = .blue
//        self.view.addSubview(filterView)
//        
//        filterView.snp.makeConstraints { make in
//            make.left.equalTo(self.view)
//            make.top.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        }
        
    }
    
    private func setupCollectionView(){
        self.storeCollectionView.dataSource = self
        self.storeCollectionView.delegate = self
        self.storeCollectionView.collectionViewLayout = createCompositionalLayout()
        self.storeCollectionView.register(Test.self, forCellWithReuseIdentifier: "Test")
        
        self.storeCollectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        self.storeCollectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Header")
        self.view.addSubview(storeCollectionView)
        
        self.storeCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(15)
            make.bottom.equalTo(self.view)
        }
    }
    
    private func setNavStyles(){
        let label = UILabel()
        label.text = "Store"
        label.textAlignment = .left
        let titleItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = titleItem
    }
    
    
    private func fetch(){
        self.viewModel.fetchData {
            
        }
    }
        
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        
        let group1Item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        group1Item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 2, trailing: 0)
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),heightDimension: .absolute(120)), subitems: [group1Item])
                
        let section1 = NSCollectionLayoutSection(group: group1)
        
        let section1Header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section1.boundarySupplementaryItems = [section1Header]
        section1.orthogonalScrollingBehavior = .paging
        
        
        let group2Item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        group2Item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 2, trailing: 0)

        let group2 = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitems: [group2Item])
        let section2 = NSCollectionLayoutSection(group: group2)
        
        let section2Header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section2.boundarySupplementaryItems = [section2Header]

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            switch sectionIndex{
            case 0:
                return section1
            case 1:
                return section2
            default:
                return section1
            }
        }
        return layout
    }
}

extension HomeScreenVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.row == 0{ //Section 1 header
            if kind == UICollectionView.elementKindSectionHeader{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
                       headerView.backgroundColor = UIColor.blue
                       return headerView
            }
        }else if indexPath.row == 1{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            headerView.backgroundColor = UIColor.green
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test", for: indexPath)
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 8
        return cell
    }
    
}
