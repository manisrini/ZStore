//
//  HomeScreenViewModek.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import Foundation
import ZChip

struct ProductModel{
    let id : String
    let name : String
    let rating : Double?
    let review_count : Int?
    let price : Double
    let category : ProductCategory?
    let cardOffers : [CardOffer]?
    let image_url : String?
    let description : String?
}


class HomeScreenViewModel{
    
    var allProducts : [Product] = []
    var availableCategories : [ProductCategory] = []
    var allOffers : [CardOffer] = []
    
    var selectedOffer : CardOffer?
    var selectedCategory : ProductCategory?
    var availableProducts : [Product] = []
    var availableProductsWithOffers : [Product] = []
    var availableOffers : [CardOffer] = []
    
    func fetchData(completion : @escaping() -> Void){
        let url = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
        
        NetworkManager.shared.getData(urlStr: url) { [weak self] data, error in
            guard let _data = data else{ return }
            
            do{
                let decoder = JSONDecoder()
                let response = try decoder.decode(HomeScreenResponse.self, from: _data)
                self?.createProductModel(response)
                completion()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func createProductModel(_ response : HomeScreenResponse){
        self.availableCategories = response.category ?? []
        self.allOffers = response.card_offers ?? []
        self.allProducts = response.products ?? []
        
        if let _selectedCategory = response.category?.first{
            self.setSelectedCategory(_selectedCategory)
        }
        
        self.updateProducts()
        self.setSelectedCategoryOffers()
        
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
        }*/

    }
    
   /* private func getCategory(product : Product,allCategories : [ProductCategory]) -> ProductCategory?{
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
    func removeOffer(){
        self.selectedOffer = nil
    }
    
    private func setSelectedCategory(_ category : ProductCategory){
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
                return cardOfferIds.contains(_selectedOffer.id)
            }
            self.availableProductsWithOffers = filteredProducts
        }
        
    }
    
    func setSelectedCategoryOffers(){
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
    
    func getCategories() -> [Tag]{
        var categories : [Tag] = []
        
        for (index,category) in self.availableCategories.enumerated() {
            if index == 0{
                categories.append(Tag(id: category.id , text: category.name ?? "", isSelected: true))
            }else{
                categories.append(Tag(id: category.id, text: category.name ?? "", isSelected: false))
            }
        }
        
        return categories
    }
    
    func createOfferCellViewModel(_ index : Int) -> OfferCellViewModel{
        let offer = self.availableOffers[index]
        return OfferCellViewModel(
            titleText: offer.card_name ?? "",
            subtitleText: offer.offer_desc ?? "",
            cashbackText: offer.max_discount ?? "",
            imageUrl: offer.image_url)
    }
    
    func createLinearLayoutProductModel(_ index : Int) -> LinearLayoutCellViewModel{
        var product = self.availableProducts[index]
        if selectedOffer != nil{
            product = self.availableProductsWithOffers[index]
        }
        
        return LinearLayoutCellViewModel(
            id : product.id,
            imageUrl: product.image_url ?? "",
            name: product.name ?? "",
            reviewCount: product.review_count ?? 0,
            rating: product.rating ?? 0.0,
            price: product.price ?? 0.0,
            desc: product.description ?? "",
            colors: product.colors)
    }
}
