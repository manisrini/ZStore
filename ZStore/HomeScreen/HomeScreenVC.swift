//
//  ViewController.swift
//  ZStore
//
//  CreateCreated by Manikandan on 19/09/24.
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
    private var searchController: UISearchController?

    var categoryFetchedResultsController: NSFetchedResultsController<CategoryData>?
    var productFetchedResultsController: NSFetchedResultsController<ProductData>?
    var cardOfferFetchedResultsController: NSFetchedResultsController<CardOfferData>?
    var dataManager = HomeScreenDataManager()
    
    var workItem : DispatchWorkItem?

    
    private let storeCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarStyles()
        self.setupSearchController()
        self.setupBaseView()
        self.setupFilterView()
        self.setupCollectionView()
        self.loadFabBtn()
        self.fetchProducts()
    }
            
    
    private func setupSearchController() {
        searchController = HomeScreenHelper.setUpSearchController()
        searchController?.searchResultsUpdater = self
    }

    @objc func didTapSearchIcon(){
        self.navigationItem.titleView = searchController?.searchBar ?? UIView()
        self.navigationItem.leftBarButtonItem = nil
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        cancelButton.tintColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)
        self.navigationItem.rightBarButtonItem = cancelButton
        searchController?.isActive = true

    }
    
    @objc func didTapCancelButton(){
        
        self.viewModel.searchStr = ""
        self.configStickyHeaderView()
        self.updateView()
        self.setNavBarStyles()
        searchController?.isActive = false
    }
    
    private func setNavBarStyles(){

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Zstore"
        label.font = .fontStyle(size: 30, weight: .bold)
        label.textAlignment = .left
        let titleItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = titleItem

        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.addTarget(self, action: #selector(didTapSearchIcon), for: .touchUpInside)

        let searchBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        self.navigationItem.titleView = nil
        
    }

    private func loadFabBtn(){
        
        let fabContainerView = UIView()
        fabContainerView.layer.cornerRadius = 25
        
        let fabView = UIHostingController(rootView: FabView(fabItems: [
            .init(id : "1",image: "star", text: "Rating", isSelected: true),
            .init(id : "2",image: "dollar", text: "Price", isSelected: false)
        ]) { [weak self] sortWith in
            if sortWith == self?.viewModel.sortWith{
                return
            }
            
            if sortWith == .Price{
                self?.viewModel.sortWith = .Price
                self?.viewModel.sortDescriptor = "price"
            }else{
                self?.viewModel.sortWith = .Rating
                self?.viewModel.sortDescriptor = "rating"
            }
            let categoryId = self?.viewModel.selectedCategory?.id ?? ""
            let cardOfferId = self?.viewModel.selectedOffer?.id
            self?.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId)
        })
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
            make.top.equalTo(self.baseView).offset(navBarHeight + 50)
            make.right.equalTo(self.baseView).offset(10)
            make.height.equalTo(100)
            self.filterViewHeightConstraint = make.height.equalTo(110).constraint
        }
    }
    
    
    private func updateListLayout(layout : String?){
        //Change the layout based on category
        if let listLayout = layout{
            if listLayout.lowercased() == ListLayout.Linear.rawValue.lowercased(){
                self.viewModel.currentLayout = .Linear
                self.storeCollectionView.collectionViewLayout = LinearCompositionFlowLayout.createCompositionalLayout()
            }else{
                self.viewModel.currentLayout = .WaterFall
                self.storeCollectionView.collectionViewLayout = WaterfallCompositionalFlowLayout.createCompositionalLayout(items: self.productFetchedResultsController?.fetchedObjects ?? [])
            }
        }

    }
        
    private func fetchProducts(){
        
        self.viewModel.fetchData(dataManager) { [weak self] in
            
            DispatchQueue.main.async {
                
                //MARK: Fetch data from DB using NSFetchedResultsController
                
                self?.categoryFetchedResultsController = self?.dataManager.setupCategoriesFetchedResultsController()
                
                self?.cardOfferFetchedResultsController = self?.dataManager.setupCardOffersFetchedResultsController()
                
                if let categories = self?.categoryFetchedResultsController?.fetchedObjects,let firstCategory = categories.first,let id = firstCategory.id{
                    self?.viewModel.selectedCategory = firstCategory
                    self?.productFetchedResultsController =  self?.dataManager.setupProductFetchedResultsController(categoryId: id
                    )
                    self?.productFetchedResultsController?.delegate = self
                    
                    self?.updateListLayout(layout: firstCategory.layout)
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
    
    private func updateProducts(categoryId : String,cardOfferId : String?,reloadList : Bool = true){
        
        if self.viewModel.searchStr.isEmptyOrWhitespace(){
            self.productFetchedResultsController = dataManager.setupProductFetchedResultsController(
                categoryId: categoryId,
                cardOfferId: cardOfferId,
                sortDescriptor: self.viewModel.sortDescriptor
            )
        }else{
            self.productFetchedResultsController = dataManager.setupProductFetchedResultsController(
                searchStr: self.viewModel.searchStr,
                categoryId: categoryId,
                cardOfferId: cardOfferId,
                sortDescriptor: self.viewModel.sortDescriptor
            )
        }
        
        if reloadList{
            self.reloadSection(at: 1)
        }
    }
    
}

extension HomeScreenVC{
    private func setupCollectionView(){
        self.storeCollectionView.dataSource = self
        self.storeCollectionView.delegate = self
        self.storeCollectionView.collectionViewLayout = LinearCompositionFlowLayout.createCompositionalLayout()
        
        self.storeCollectionView.register(UINib(nibName: CellIdentifiers.TagCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.TagCell)
        
        self.storeCollectionView.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.OfferCell)
        self.storeCollectionView.register(LinearLayoutCell.self, forCellWithReuseIdentifier: CellIdentifiers.LinearLayoutCell)
        self.storeCollectionView.register(WaterfallLayoutCell.self, forCellWithReuseIdentifier: CellIdentifiers.WaterfallLayoutCell)
        self.storeCollectionView.register(OfferSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIdentifiers.OfferSectionHeaderView)
        self.storeCollectionView.register(OfferSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellIdentifiers.OfferSectionFooterView)
        
        self.baseView.addSubview(storeCollectionView)
        
        self.storeCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self.baseView)
            make.right.equalTo(self.baseView)
            make.top.equalTo(self.filterView.snp.bottom)
            make.bottom.equalTo(self.baseView)
        }
    }
}

extension HomeScreenVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 { // offer section header
            if kind == UICollectionView.elementKindSectionHeader{
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIdentifiers.OfferSectionHeaderView, for: indexPath) as? OfferSectionHeaderView{
                    return headerView
                }
            }
            
            else if kind == UICollectionView.elementKindSectionFooter{ //offer section footer
                if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIdentifiers.OfferSectionFooterView, for: indexPath) as? OfferSectionFooterView{
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
            if let selectedOffer = self.cardOfferFetchedResultsController?.object(at: IndexPath(row: indexPath.row, section: 0)){
                
                if selectedOffer == self.viewModel.selectedOffer{
                    return
                }
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
            if productFetchedResultsController?.sections?.first?.numberOfObjects ?? 0 == 0{
                collectionView.setEmptyMessageText("No products found", textColor: .black)
            }else{
                collectionView.setEmptyMessageText("", textColor: .clear)
            }
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
                self.updateListLayout(layout: newSelectedCategory.layout)
            }
            self.updateProducts(categoryId: item.id, cardOfferId: nil)
            self.scrollToTop()
            self.storeCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func scrollToTop(){
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.storeCollectionView.scrollToItem(at: firstIndexPath, at: .top, animated: true)

    }
    
    func didChangeHeight(height: CGFloat) {
        self.filterViewHeightConstraint?.update(offset: height + 20)
        self.filterView.layoutIfNeeded()
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
        let categoryId = self.viewModel.selectedCategory?.id ?? ""
        let cardOfferId = self.viewModel.selectedOffer?.id
        self.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId,reloadList: false)
    }
    
    func didTapAddToFavButton(productId: String) {
        self.viewModel.updateProduct(dataManager: dataManager, productId: productId, isFavourite: true)
        let categoryId = self.viewModel.selectedCategory?.id ?? ""
        let cardOfferId = self.viewModel.selectedOffer?.id
        self.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId,reloadList: false)
    }
}

extension HomeScreenVC : NSFetchedResultsControllerDelegate{
    
}

extension HomeScreenVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if !(self.viewModel.searchStr == searchText){
            self.workItem?.cancel()
            
            self.workItem = DispatchWorkItem{
                self.viewModel.searchStr = searchText
                self.updateView()
            }
            if let _workItem = workItem{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: _workItem)
            }
        }
    }
    
    private func updateView(){ //update category view to show count , refresh the list
        let categoryId = self.viewModel.selectedCategory?.id ?? ""
        let cardOfferId = self.viewModel.selectedOffer?.id
        self.updateProducts(categoryId: categoryId, cardOfferId: cardOfferId,reloadList: false)
        self.filterView.updateItem(tag: self.viewModel.getSearchTag(fetchController: productFetchedResultsController))
        self.storeCollectionView.reloadData()
    }

}

