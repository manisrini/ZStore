//
//  HomeScreenViewModek.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import Foundation
import ZChip
import CoreData
import NetworkManager

enum SortWith{
    case Rating
    case Price
}

enum ListLayout : String {
    case WaterFall
    case Linear
}

class HomeScreenViewModel{
    
    var selectedOffer : CardOfferData?
    var selectedCategory : CategoryData?
    var currentLayout : ListLayout = .Linear
    var searchStr : String = ""
    var sortDescriptor : String = "rating"
    var sortWith : SortWith = .Rating
    
    func fetchData(_ dataManager : HomeScreenDataManager,completion : @escaping() -> Void){
        
        if dataManager.hasDataInDB(){
            completion()
        }else{
            
            let url = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
            
            NetworkManager.shared.getData(urlStr: url) { [weak self] data, error in
                guard let _data = data else{ return }
                
                do{
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(HomeScreenResponse.self, from: _data)
                    self?.saveData(dataManager: dataManager,response: response)
                    completion()
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    private func saveData(dataManager : HomeScreenDataManager,response : HomeScreenResponse){ ///Save data in database

        dataManager.saveCategories(categories: response.category ?? []) { result in
            switch result {
            case .success(_):
                print("categories saved")
            case .failure(_):
                print("categories failed")
            }
        }
        
        
        dataManager.saveOffers(cardOffers: response.card_offers ?? [], completionHandler: { result in
            switch result {
            case .success(_):
                print("offers saved")
            case .failure(_):
                print("offers failed")
            }

        })
        
        dataManager.saveProducts(products: response.products ?? []) { result in
            switch result {
            case .success(_):
                print("products saved")
            case .failure(_):
                print("products failed")
            }
        }
    }
    
    func removeOffer(){
        self.selectedOffer = nil
    }
    
    func getCategories(availableCategories : [CategoryData]) -> [Tag]{
        var categories : [Tag] = []
        
        for (index,category) in availableCategories.enumerated() {
            if index == 0{
                categories.append(Tag(id: category.id ?? "" , text: category.name ?? "", isSelected: true))
            }else{
                categories.append(Tag(id: category.id ?? "", text: category.name ?? "", isSelected: false))
            }
        }
        return categories
    }
    
    func updateProduct(dataManager : HomeScreenDataManager,productId : String,isFavourite : Bool){
        dataManager.updateProduct(withId: productId, isFavourite: isFavourite) { result in
            
        }
    }
    
    
    
    func offersAvailable(for product : ProductData) -> OfferPrice?{
        if let _cardOffer = self.selectedOffer{
            let amountSaved = Double(product.price) / _cardOffer.percentage
            let offerPrice = Double(product.price) - amountSaved
            return OfferPrice(amountSaved: Int(amountSaved) + 1, offerPrice: Int(offerPrice))
        }
        return nil
        
    }
    
    func getSearchTag(fetchController : NSFetchedResultsController<ProductData>?) -> Tag{ //Show the count while searching
        let selectedCategoryName = self.selectedCategory?.name ?? ""
        let selectedCategoryId = self.selectedCategory?.id ?? ""
        
        if self.searchStr.isEmptyOrWhitespace(){
            return Tag(id: selectedCategoryId, text: selectedCategoryName.capitalized)
        }else{
            let productCount = fetchController?.fetchedObjects?.count ?? 0
            return Tag(id: selectedCategoryId, text: "\(selectedCategoryName.capitalized) (\(productCount))")
        }
    }

    
    //MARK: Create ViewModels
    
    func createOfferCellViewModel(_ offer : CardOfferData) -> OfferCellViewModel{
        return OfferCellViewModel(
            titleText: offer.card_name ?? "",
            subtitleText: offer.offer_desc ?? "",
            cashbackText: offer.max_discount ?? "",
            imageUrl: offer.image_url)
    }

    
    func createLinearLayoutProductModel(product : ProductData) -> LinearLayoutCellViewModel{
        
        let _offer = self.offersAvailable(for: product)
        
        return LinearLayoutCellViewModel(
            id : product.id ?? "",
            imageUrl: product.image_url ?? "",
            name: product.name ?? "",
            reviewCount: Int(product.review_count),
            rating: product.rating,
            price: Double(product.price),
            desc: product.desc ?? "",
            colors: product.colors?.toArray(),
            offer: _offer)
    }
    
    func createWaterfallLayoutProductModel(product : ProductData) -> WaterfallLayoutCellViewModel{
        
        let _offer = self.offersAvailable(for: product)

        return WaterfallLayoutCellViewModel(
            id: product.id ?? "",
            imageUrl: product.image_url ?? "",
            name: product.name ?? "",
            reviewCount: Int(product.review_count),
            rating: product.rating,
            price: Double(product.price),
            desc: product.desc ?? "",
            isFavourite: product.isFavourite,
            offer: _offer
        )
    }
}
