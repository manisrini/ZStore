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
import CoreData
import SwiftUI

final class HomeScreenVC: UIViewController {
    
    var viewModel = HomeScreenViewModel()
    
    private var filterView = FilterView()
    var filterViewHeightConstraint: Constraint?
    private var baseView = UIView()
    private var offerSectionFooterView : OfferSectionFooterView?
    
    var categoryFetchedResultsController: NSFetchedResultsController<CategoryData>?
    var productFetchedResultsController: NSFetchedResultsController<ProductData>?
    var cardOfferFetchedResultsController: NSFetchedResultsController<CardOfferData>?
    var dataManager = HomeScreenDataManager()
    var workItem : DispatchWorkItem?

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
        
        if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                    print("Core Data Path : Documents Directory: \(directoryLocation)Application Support")
         }

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
        searchBar.delegate = self
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
        self.storeCollectionView.collectionViewLayout = LinearCompositionFlowLayout.createCompositionalLayout()
        
        self.storeCollectionView.register(Test.self, forCellWithReuseIdentifier: "Test")
        self.storeCollectionView.register(UINib(nibName: CellIdentifiers.TagCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.TagCell)
        
        self.storeCollectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.OfferCell)
        self.storeCollectionView.register(LinearLayoutCell.self, forCellWithReuseIdentifier: CellIdentifiers.LinearLayoutCell)
        self.storeCollectionView.register(WaterfallLayoutCell.self, forCellWithReuseIdentifier: CellIdentifiers.WaterfallLayoutCell)
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
    
    private func updateListLayout(category : CategoryData){
        //Change the layout based on categotory
        if let listLayout = category.layout{
            if listLayout.lowercased() == ListLayout.Linear.rawValue.lowercased(){
                self.viewModel.currentLayout = .Linear
                self.storeCollectionView.collectionViewLayout = LinearCompositionFlowLayout.createCompositionalLayout()
            }else{
                self.viewModel.currentLayout = .WaterFall
                self.storeCollectionView.collectionViewLayout = WaterfallCompositionalFlowLayout.createCompositionalLayout()
            }
        }

    }
        
    private func fetchProducts(){
        
        self.viewModel.fetchData(dataManager) { [weak self] in
            
            DispatchQueue.main.async {
                
                self?.categoryFetchedResultsController = self?.dataManager.setupCategoriesFetchedResultsController()
                
                self?.cardOfferFetchedResultsController = self?.dataManager.setupCardOffersFetchedResultsController()
                
                if let categories = self?.categoryFetchedResultsController?.fetchedObjects,let firstCategory = categories.first,let id = firstCategory.id{
                    self?.viewModel.selectedCategory = firstCategory
                    self?.productFetchedResultsController =  self?.dataManager.setupProductFetchedResultsController(categoryId: id
                    )
                    self?.productFetchedResultsController?.delegate = self
                    
                    self?.updateListLayout(category: firstCategory)
                }
                
                self?.configStickyHeaderView()
                
                self?.storeCollectionView.reloadData()
            }
        }
    }
            
    private func configStickyHeaderView(){
        if let availableCategories = categoryFetchedResultsController?.fetchedObjects{
            let items = self.viewModel.getCategories(availableCategories: availableCategories)
            self.filterView.updateView(items)
        }
        
    }
    
    private func reloadSection(at section : Int){
        self.storeCollectionView.reloadSections(IndexSet(integer: section))
    }
    
    private func updateProducts(categoryId : String,cardOfferId : String?,searchStr : String? = nil){
        if let _searchStr = searchStr{
            if _searchStr.isEmptyOrWhitespace(){
                self.productFetchedResultsController = dataManager.setupProductFetchedResultsController(categoryId: categoryId,cardOfferId: cardOfferId)
            }else{
                self.productFetchedResultsController = dataManager.setupProductFetchedResultsController(searchStr: _searchStr, categoryId: categoryId,cardOfferId: cardOfferId)
            }
        }else{
            self.productFetchedResultsController = dataManager.setupProductFetchedResultsController(categoryId: categoryId, cardOfferId: cardOfferId)
        }
        self.reloadSection(at: 1)
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
            if  let selectedOffer = self.cardOfferFetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)){
                
                self.viewModel.selectedOffer = selectedOffer
                self.offerSectionFooterView?.config(value: selectedOffer.card_name)
                
                let selectedCategoryId = self.viewModel.selectedCategory?.id ?? ""
                self.updateProducts(categoryId: selectedCategoryId, cardOfferId: selectedOffer.id)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return cardOfferFetchedResultsController?.sections?.first?.numberOfObjects ?? 0
        } else {
            return productFetchedResultsController?.sections?.first?.numberOfObjects ?? 0
        }
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    
            if indexPath.section == 0{ // OfferSection
                if let offerCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.OfferCell, for: indexPath) as? OfferCollectionViewCell{
                    if let cardOffer = cardOfferFetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)){
                        let offerVM = self.viewModel.createOfferCellViewModel(cardOffer)
                        offerCell.config(viewModel: offerVM)
                        return offerCell
                    }
                }
            }
            else if indexPath.section == 1{
                if self.viewModel.currentLayout == .Linear{
                    if let linearCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.LinearLayoutCell, for: indexPath) as? LinearLayoutCell{
                        
                        if let product = productFetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)){
                            let productVM = self.viewModel.createLinearLayoutProductModel(product: product)
                            linearCell.config(with: productVM)
                            return linearCell
                        }
                    }
                }else{
                    if let waterfallCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.WaterfallLayoutCell, for: indexPath) as? WaterfallLayoutCell{
                        
                        if let product = productFetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)){
                            waterfallCell.delegate = self
                            let productVM = self.viewModel.createWaterfallLayoutProductModel(product: product)
                            waterfallCell.config(with: productVM)
                            return waterfallCell
                        }
                    }
                }
            }
            
            return UICollectionViewCell()
        }
    
}


extension HomeScreenVC : FilterViewDelegate{
    func didChangeCategory(item: Tag) {
                
        if let availableCategories = categoryFetchedResultsController?.fetchedObjects{
            if let newSelectedCategory = availableCategories.filter({$0.id ?? "" == item.id}).first{
                self.viewModel.selectedCategory = newSelectedCategory
                self.updateListLayout(category: newSelectedCategory)
            }
    //        self.viewModel.updateProducts()
    //        self.viewModel.updateOffers()
    //        self.fetchProducts()

            self.updateProducts(categoryId: item.id, cardOfferId: nil)
            self.storeCollectionView.reloadData()
            
            self.storeCollectionView.collectionViewLayout.invalidateLayout()
        }
        
    }
}

extension HomeScreenVC : OfferSectionFooterViewDelegate{
    func didTapButton() {
        self.viewModel.removeOffer()
        if let selectedCategoryId = self.viewModel.selectedCategory?.id{
            self.updateProducts(categoryId: selectedCategoryId , cardOfferId: nil)
        }
    }
}

extension HomeScreenVC : WaterfallLayoutCellDelegate{
    func didTapFavButton(productId: String) {
        self.viewModel.updateProduct(dataManager: dataManager, productId: productId, isFavourite: false)
    }
    
    func didTapAddToFavButton(productId: String) {
        self.viewModel.updateProduct(dataManager: dataManager, productId: productId, isFavourite: true)
    }
}

extension HomeScreenVC : NSFetchedResultsControllerDelegate{
    
}

extension HomeScreenVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.workItem?.cancel()
        
        self.workItem = DispatchWorkItem{
            let categoryId = self.viewModel.selectedCategory?.id ?? ""
            let cardOfferId = self.viewModel.selectedOffer?.id
            self.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId,searchStr: searchText)
        }
        if let _workItem = workItem{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: _workItem)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let categoryId = self.viewModel.selectedCategory?.id ?? ""
        let cardOfferId = self.viewModel.selectedOffer?.id
        self.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId)
    }
}
