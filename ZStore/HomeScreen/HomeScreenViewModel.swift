//
//  HomeScreenViewModek.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import Foundation

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
    
    var productItems : [ProductModel] = []
    var availableCategories : [ProductCategory] = []
    
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
        
        var formattedProducts : [ProductModel] = []
        
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
        
        print(formattedProducts)
    }
    
    private func getCategory(product : Product,allCategories : [ProductCategory]) -> ProductCategory?{
        let categoryId = product.category_id ?? ""
        let filteredCategory = allCategories.filter { category in
            category.id ?? "" == categoryId
        }.first
        return filteredCategory
    }
    
    private func getCardOffers(product : Product,allCardOffers : [CardOffer]) -> [CardOffer]?{
        let currentProductCardOffersIds = product.card_offer_ids ?? []
        var currentProductOffers : [CardOffer] = []
        
        for offer in allCardOffers {
            let offerId = offer.id ?? ""
            if currentProductCardOffersIds.contains(offerId){
                currentProductOffers.append(offer)
            }
        }
        return currentProductOffers
    }
    
}
