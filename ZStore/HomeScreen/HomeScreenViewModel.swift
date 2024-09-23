//
//  HomeScreenViewModek.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import Foundation
import ZChip

enum SortWith{
    case Rating
    case Price
}

enum ListLayout : String {
    case WaterFall
    case Linear
}

class HomeScreenViewModel{
    
    var allProducts : [Product] = []
    var availableCategories : [ProductCategory] = []
    var allOffers : [CardOffer] = []
    
    var selectedOffer : CardOfferData?
    var selectedCategory : CategoryData?
    var availableProducts : [Product] = []
    var availableProductsWithOffers : [Product] = []
    var availableOffers : [CardOffer] = []
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
    
    func fetchSearchedProducts(dataManager : HomeScreenDataManager,searchText : String,categoryId : String,cardOfferId : String?){

    }
    
    /*private func setSelectedCategory(_ category : CategoryData){
        self.selectedCategory = category
    }

    
    func updateProducts(){
        if let _selectedCategoryId = self.selectedCategory?.id{
            self.availableProducts = allProducts.filter { product in
                product.category_id ?? "" == _selectedCategoryId
            }
        }
        
        self.updateProductsWithOffers()
    }
    
    
    func updateProductsWithOffers(){
        if let _selectedOffer = self.selectedOffer{
            let filteredProducts = self.availableProducts.filter { product in
                let cardOfferIds = product.card_offer_ids ?? []
                return cardOfferIds.contains(_selectedOffer.id ?? "")
            }
            self.availableProductsWithOffers = filteredProducts
        }
        
    }
    
    func updateOffers(){
        var tempOffers : [CardOffer] = []
        
        if let _selectedCategoryId = self.selectedCategory?.id{
            for product in availableProducts {
                let productOfferIds = product.card_offer_ids ?? []
                
                for offerId in productOfferIds{
                    if !tempOffers.contains(where: { cardOffer in
                        cardOffer.id == offerId
                    }){
                        if let _offer = self.getOffer(id: offerId){
                            tempOffers.append(_offer)
                        }
//
//                        if selectedCategoryOffers.count == allOffers.count{
//                            break
//                        }
                    }
                }
            }
        }
        
        self.availableOffers = tempOffers
    }
    
    func getOffer(id : String) -> CardOffer?{
        return self.allOffers.filter { offer in
            offer.id == id
        }.first
    }
    
    func getProductCount() -> Int{
        if selectedOffer == nil{
            return self.availableProducts.count
        }
        return self.availableProductsWithOffers.count
    }
*/
    
    func createOfferCellViewModel(_ offer : CardOfferData) -> OfferCellViewModel{
        return OfferCellViewModel(
            titleText: offer.card_name ?? "",
            subtitleText: offer.offer_desc ?? "",
            cashbackText: offer.max_discount ?? "",
            imageUrl: offer.image_url)
    }
    
    func offersAvailable(for product : ProductData) -> OfferPrice?{
        if let _cardOffer = self.selectedOffer{
            let amountSaved = Double(product.price) / _cardOffer.percentage
            let offerPrice = Double(product.price) - amountSaved
            return OfferPrice(amountSaved: Int(amountSaved) + 1, offerPrice: Int(offerPrice))
        }
        return nil
        
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
            isFavourite: product.isFavourite
        )
    }
    
}


/*var formattedProducts : [ProductModel] = []

if let _products = response.products{
    for product in _products {
        let category = self.getCategory(product: product, allCategories: response.category ?? [])
        let cardOffers = self.getCardOffers(product: product, allCardOffers: response.card_offers ?? [])
        let formattedProduct = ProductModel(
            id: product.id ?? "",
            name: product.name ?? "",
            rating: product.rating,
            review_count: product.review_count,
            price: product.price ?? 0.0,
            category: category,
            cardOffers: cardOffers,
            image_url: product.image_url,
            description: product.description)
        formattedProducts.append(formattedProduct)
    }
}

 private func getCategory(product : Product,allCategories : [ProductCategory]) -> ProductCategory?{
if let _categoryId = product.category_id{
    let filteredCategory = allCategories.filter { category in
        category.id ?? "" == _categoryId
    }.first
    return filteredCategory
}
return nil
}

private func getCardOffers(product : Product,allCardOffers : [CardOffer]) -> [CardOffer]?{
let currentProductCardOffersIds = product.card_offer_ids ?? []
var currentProductOffers : [CardOffer] = []

for offer in allCardOffers {
    if let _offerId = offer.id{
        if currentProductCardOffersIds.contains(_offerId){
            currentProductOffers.append(offer)
        }
    }
}
return currentProductOffers
}*/
