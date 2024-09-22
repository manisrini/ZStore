//
//  ViewController.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import UIKit
import SnapKit
import ZChip
import DesignSystem
import SwiftUI

class HomeScreenVC: UIViewController {
    
    var viewModel = HomeScreenViewModel()
    
    private var filterView = FilterView()
    var filterViewHeightConstraint: Constraint?
    private var baseView = UIView()
    private var offerSectionFooterView : OfferSectionFooterView?
    
    lazy var searchBar : UISearchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.main.bounds.size.width * 0.9, 20))

    
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
        self.setUpSearchBar()
        self.setupBaseView()
        self.setupFilterView()
        self.setupCollectionView()
        self.loadFabBtn()
        self.fetchProducts()
    }
    
    private func setNavStyles(){
        let label = UILabel()
        label.text = "Store"
        label.textAlignment = .left
        let titleItem = UIBarButtonItem(customView: label)
        titleItem.tintColor = .white
        self.navigationItem.leftBarButtonItem = titleItem
    }
    
    private func setUpSearchBar(){
        searchBar.placeholder = "Placeholder"
        searchBar.showsCancelButton = true
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    

    private func loadFabBtn(){
        
        let fabContainerView = UIView()
        fabContainerView.layer.cornerRadius = 25
        
        let fabView = UIHostingController(rootView: FabView())
        fabView.view.layer.cornerRadius = 25
        
        fabContainerView.addSubview(fabView.view)
        
        fabView.view.snp.makeConstraints { make in
            make.left.equalTo(fabContainerView)
            make.right.equalTo(fabContainerView)
            make.top.equalTo(fabContainerView)
            make.bottom.equalTo(fabContainerView)
        }
        
        self.baseView.addSubview(fabContainerView)

        fabContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(baseView).offset(-20)
            make.right.equalTo(baseView).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(50)
         }
    }
    
    @objc func didTapFabBtn(){
        
    }

    private func setupBaseView(){
        baseView.backgroundColor = .white
        self.view.addSubview(baseView)

        baseView.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    private func setupFilterView(){
        filterView.delegate = self
        self.baseView.addSubview(filterView)
        let navBarHeight = (self.navigationController?.navigationBar.frame.height ?? 0)

        filterView.snp.makeConstraints { make in
            make.left.equalTo(self.baseView).offset(10)
            make.top.equalTo(self.baseView).offset(navBarHeight + 40)
            make.right.equalTo(self.baseView).offset(10)
            make.height.equalTo(110)
            self.filterViewHeightConstraint = make.height.equalTo(110).constraint
        }
    }
    
    private func setupCollectionView(){
        self.storeCollectionView.dataSource = self
        self.storeCollectionView.delegate = self
        self.storeCollectionView.collectionViewLayout = createCompositionalLayout()
        self.storeCollectionView.register(Test.self, forCellWithReuseIdentifier: "Test")
        self.storeCollectionView.register(UINib(nibName: CellIdentifiers.TagCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.TagCell)
        
        self.storeCollectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.OfferCell)
        self.storeCollectionView.register(LinearLayoutCell.self, forCellWithReuseIdentifier: CellIdentifiers.LinearLayoutCell)
        self.storeCollectionView.register(OfferSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "OfferSectionHeaderView")
        self.storeCollectionView.register(OfferSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "OfferSectionFooterView")
        
        self.baseView.addSubview(storeCollectionView)
        
        self.storeCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self.baseView)
            make.right.equalTo(self.baseView)
            make.top.equalTo(self.filterView.snp.bottom)
            make.bottom.equalTo(self.baseView)
        }
    }
        
    private func fetchProducts(){
        if self.viewModel.allProducts.count == 0{
            self.viewModel.fetchData {
                DispatchQueue.main.async {
                    self.configStickyHeaderView()
                    self.storeCollectionView.reloadData()
                }
            }
        }else{
            self.storeCollectionView.reloadData()
        }
    }
    
    private func getNewProducts(){
        self.storeCollectionView.reloadData()
    }
        
    private func configStickyHeaderView(){
        let items = self.viewModel.getCategories()
        self.filterView.updateView(items)
    }
    
    private func reloadSection(at section : Int){
        self.storeCollectionView.reloadSections(IndexSet(integer: section))
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        
        let section1GroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        section1GroupItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 2, trailing: 12)
        let section1Group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),heightDimension: .absolute(120)), subitems: [section1GroupItem])
        let section1 = NSCollectionLayoutSection(group: section1Group)
        let section1Header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let section1Footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section1.boundarySupplementaryItems = [section1Header,section1Footer]
        section1.orthogonalScrollingBehavior = .continuous
        
        
        let section2GroupItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        section2GroupItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 12, bottom: 20, trailing: 0)
        let section2Group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(250)), subitems: [section2GroupItem])
        let section2 = NSCollectionLayoutSection(group: section2Group)
        

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0{ // offer section header
            if kind == UICollectionView.elementKindSectionHeader{
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OfferSectionHeaderView", for: indexPath) as? OfferSectionHeaderView{
                    return headerView
                }
            }
            
            else if kind == UICollectionView.elementKindSectionFooter{
                if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OfferSectionFooterView", for: indexPath) as? OfferSectionFooterView{
                    self.offerSectionFooterView = footerView
                    footerView.config(value: self.viewModel.selectedOffer?.card_name)
                    footerView.delegate = self
                    return footerView
                }
            }
        }
        
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{ // Offers section
            let selectedOffer = self.viewModel.availableOffers[indexPath.row]
            self.viewModel.selectedOffer = selectedOffer
            self.offerSectionFooterView?.config(value: selectedOffer.card_name)
            self.viewModel.updateProductsWithOffers()
            self.reloadSection(at: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return self.viewModel.availableOffers.count
        }else if section == 1{
            return self.viewModel.getProductCount()
        }
        return 0
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    
            if indexPath.section == 0{ // OfferSection
                if let offerCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.OfferCell, for: indexPath) as? OfferCollectionViewCell{
                    let offerVM = self.viewModel.createOfferCellViewModel(indexPath.row)
                    offerCell.config(viewModel: offerVM)
                    return offerCell
                }
            }
            else if indexPath.section == 1{
                if let linearCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.LinearLayoutCell, for: indexPath) as? LinearLayoutCell{
                    let productVM = self.viewModel.createLinearLayoutProductModel(indexPath.row)
                    linearCell.config(viewModel: productVM)
                    return linearCell
                }
            }
            
    //        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test", for: indexPath) as? Test{
    //            cell.backgroundColor = .red
    //            cell.layer.cornerRadius = 8
    //            return cell
    //        }
            return UICollectionViewCell()
        }
    
}


extension HomeScreenVC : FilterViewDelegate{
    func didChangeCategory(item: Tag) {
                
        if let newSelectedCategory = self.viewModel.availableCategories.filter({$0.id == item.id}).first{
            self.viewModel.selectedCategory = newSelectedCategory
        }
        self.viewModel.updateProducts()
        self.viewModel.setSelectedCategoryOffers()
        self.fetchProducts()
    }
}

extension HomeScreenVC : OfferSectionFooterViewDelegate{
    func didTapButton() {
        self.viewModel.removeOffer()
        self.reloadSection(at: 1)
    }
}
