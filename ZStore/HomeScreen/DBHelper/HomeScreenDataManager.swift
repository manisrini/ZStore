//
//  Product_DataHelper.swift
//  ZStore
//
//  Created by Manikandan on 22/09/24.
//

import Foundation
import CoreData

enum Entity : String{
    case CardOffer = "CardOfferData"
    case Product = "ProductData"
    case Category = "CategoryData"
}

class HomeScreenDataManager
{
    let dbManager : DBManager = DBManager()
    
    public func saveCategories(categories : [ProductCategory],completionHandler: @escaping(Result<Bool, Error>) -> Void){
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.Category.rawValue, in: managedContext){
            
            for category in categories {
                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? CategoryData{
                    dbObj.id = category.id
                    dbObj.layout = category.layout
                    dbObj.name = category.name
                }
            }
            
            dbManager.saveContext(managedObjectContext: managedContext) { result in
                switch result {
                case .success(_):
                    completionHandler(.success(true))
                default:
                    completionHandler(.success(false))
                }
            }
        }
    }
    
    public func saveOffers(cardOffers : [CardOffer],completionHandler: @escaping(Result<Bool, Error>) -> Void){
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.CardOffer.rawValue, in: managedContext){
            
            for offer in cardOffers {
                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? CardOfferData{
                    dbObj.id = offer.id
                    dbObj.card_name = offer.card_name
                    dbObj.image_url = offer.image_url
                    dbObj.max_discount = offer.max_discount
                    dbObj.offer_desc = offer.offer_desc
                    dbObj.percentage = offer.percentage ?? 0.0
                }
            }
            
            dbManager.saveContext(managedObjectContext: managedContext) { result in
                switch result {
                case .success(_):
                    completionHandler(.success(true))
                default:
                    completionHandler(.success(false))
                }
            }
        }
    }
    
    
    public func saveProducts(products : [Product],completionHandler: @escaping(Result<Bool, Error>) -> Void){
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.Product.rawValue, in: managedContext){
            
            for product in products {
                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? ProductData{
                    dbObj.id = product.id
                    dbObj.desc = product.description
                    dbObj.image_url = product.image_url
                    dbObj.name = product.name
                    dbObj.isFavourite = false
                    dbObj.price = Int64(product.price ?? 0)
                    dbObj.rating = product.rating ?? 0
                    dbObj.review_count = Int32(product.review_count ?? 0)
                    dbObj.colors = product.colors?.toData()
                    dbObj.category_id = product.category_id
                    if let cardOfferIds = product.card_offer_ids {
                        print(cardOfferIds.joined(separator: ","))
                        dbObj.card_offers_ids = cardOfferIds.joined(separator: ",")
                    }
                }
            }
            
            dbManager.saveContext(managedObjectContext: managedContext) { result in
                switch result {
                case .success(_):
                    completionHandler(.success(true))
                default:
                    completionHandler(.success(false))
                }
            }
        }
    }
        
//    func setupFetchedResultsController<T : NSManagedObject>(for entity : T.Type, sortKey : String) ->  NSFetchedResultsController<T>? where T: NSFetchRequestResult {
//
//        if let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T>{
//            let context = DBManager.shared.persistentContainer.viewContext
//            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
//            fetchRequest.sortDescriptors = [sortDescriptor]
//            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            
//            do {
//                try fetchedResultsController.performFetch()
//            }catch{
//                print("Failed to fetch \(T.self): \(error)")
//            }
//            
//            return fetchedResultsController
//        }
//        
//        return nil
//    }
    
    public func getProducts(withId productId: String, isFavourite: Bool, completionHandler: @escaping(Result<Bool, Error>) -> Void) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ProductData> = ProductData.fetchRequest()
        fetchRequest.predicate = DBQueries.filterBy(productId: productId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let productToUpdate = results.first {
                productToUpdate.isFavourite = isFavourite

                dbManager.saveContext(managedObjectContext: managedContext) { result in
                    switch result {
                    case .success(_):
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            } else {
                completionHandler(.success(false))
            }
            
        } catch let error as NSError {
            completionHandler(.failure(error))
        }
    }
    
    public func updateProduct(withId productId: String, isFavourite: Bool, completionHandler: @escaping(Result<Bool, Error>) -> Void) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ProductData> = ProductData.fetchRequest()
        fetchRequest.predicate = DBQueries.filterBy(productId: productId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let productToUpdate = results.first {
                productToUpdate.isFavourite = isFavourite

                dbManager.saveContext(managedObjectContext: managedContext) { result in
                    switch result {
                    case .success(_):
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            } else {
                completionHandler(.success(false))
            }
            
        } catch let error as NSError {
            completionHandler(.failure(error))
        }
    }
    
    func setupCardOffersFetchedResultsController() -> NSFetchedResultsController<CardOfferData>{
        let fetchRequest : NSFetchRequest<CardOfferData> = CardOfferData.fetchRequest()
        let context = DBManager.shared.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "card_name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let cardOffersFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try cardOffersFetchedResultsController.performFetch()
        }catch{
            print("failed to fetch cat")
        }
        return cardOffersFetchedResultsController
    }
    
    func setupCategoriesFetchedResultsController() -> NSFetchedResultsController<CategoryData>{
        let fetchRequest : NSFetchRequest<CategoryData> = CategoryData.fetchRequest()
        let context = DBManager.shared.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let categoriesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try categoriesFetchedResultsController.performFetch()
        }catch{
            print("failed to fetch cat")
        }
        return categoriesFetchedResultsController
    }
    
    func setupProductFetchedResultsController(searchStr : String,categoryId : String,cardOfferId : String? = nil,sortDescriptor : String = "rating") -> NSFetchedResultsController<ProductData>{
        
        let fetchRequest : NSFetchRequest<ProductData> = ProductData.fetchRequest()
        let context = DBManager.shared.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchRequest.predicate = DBQueries.filterBy(categoryId: categoryId, searchStr: searchStr, cardOfferId: cardOfferId)
        
        let productFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try productFetchedResultsController.performFetch()
        }catch{
            print("failed to fetch products")
        }
        
        return productFetchedResultsController
    }

    func setupProductFetchedResultsController(categoryId : String,cardOfferId : String? = nil,sortDescriptor : String = "rating") -> NSFetchedResultsController<ProductData>{
        
        let fetchRequest : NSFetchRequest<ProductData> = ProductData.fetchRequest()
        let context = DBManager.shared.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchRequest.predicate = DBQueries.filterBy(categoryId: categoryId)
        
        if let _cardOfferId = cardOfferId{
            fetchRequest.predicate = DBQueries.filterBy(cardOfferId: _cardOfferId, categoryId: categoryId)
        }
        
        let productFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try productFetchedResultsController.performFetch()
        }catch{
            print("failed to fetch products")
        }
        
        return productFetchedResultsController
    }
    
    func hasDataInDB() -> Bool {
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Product.rawValue)
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Category.rawValue)
        let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Category.rawValue)
        let managedContext = dbManager.persistentContainer.viewContext

        do {
            let count1 = try managedContext.count(for: fetchRequest1)
            let count2 = try managedContext.count(for: fetchRequest2)
            let count3 = try managedContext.count(for: fetchRequest3)
            return count1 > 0 && count2 > 0 && count3 > 0
        } catch {
            return false
        }
    }
    
    /*func fetchCategories(completionHandler : @escaping(Result<[ProductCategory],Error>) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Category.rawValue)
        let managedContext = dbManager.persistentContainer.viewContext
        
        do {
            // Perform the fetch
            let result = try managedContext.fetch(request)
            if let _categories = result as? [CategoryData]{
                var categoryModelArray : [ProductCategory] = []
                
                for category in _categories{
                    let categoryModel = ProductCategory(
                        id: category.id ?? "",
                        name: category.name,
                        layout: category.layout
                    )
                    categoryModelArray.append(categoryModel)
                }
                completionHandler(.success(categoryModelArray))
            }else{
                completionHandler(.success([]))
            }
        } catch {
            completionHandler(.failure(error))
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func fetchCardOffers(completionHandler : @escaping(Result<[CardOffer],Error>) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.CardOffer.rawValue)
        let managedContext = dbManager.persistentContainer.viewContext
        
        do {
            // Perform the fetch
            let result = try managedContext.fetch(request)
            if let _cardOffers = result as? [CardOffer]{
                var cardOfferModelArray : [CardOffer] = []
                
                for offer in _cardOffers{
                    let cardOfferModel = CardOffer(
                        id: offer.id,
                        percentage: offer.percentage,
                        offer_desc: offer.offer_desc,
                        card_name: offer.card_name,
                        max_discount: offer.max_discount,
                        image_url: offer.image_url
                    )
                    cardOfferModelArray.append(cardOfferModel)
                }
                completionHandler(.success(cardOfferModelArray))
            }else{
                completionHandler(.success([]))
            }
        } catch {
            completionHandler(.failure(error))
            print("Failed to fetch offers: \(error)")
        }
    }
    
    func fetchProducts(completionHandler : @escaping(Result<[Product],Error>) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Product.rawValue)
        let managedContext = dbManager.persistentContainer.viewContext
        
        do {
            // Perform the fetch
            let result = try managedContext.fetch(request)
            if let _products = result as? [ProductData]{
                var productModelArray : [Product] = []
                
                for product in _products{
                    let productModel = Product(
                        id: product.id ?? "",
                        name: product.name ?? "",
                        rating: product.rating,
                        review_count: Int(product.review_count),
                        price: Double(product.price),
                        category_id: product.category_id ?? "",
                        card_offer_ids: product.card_offers_ids?.toArray(),
                        image_url: product.image_url,
                        description: product.desc,
                        colors: product.colors?.toArray())
                    productModelArray.append(productModel)
                }
                completionHandler(.success(productModelArray))
            }else{
                completionHandler(.success([]))
            }
        } catch {
            completionHandler(.failure(error))
            print("Failed to fetch products: \(error)")
        }
    }*/
}

extension Data{
    func toArray() -> [String]{
        do {
            let stringArray = try JSONDecoder().decode([String].self, from: self)
            return stringArray
        } catch {
            print("Failed to decode JSON: \(error)")
        }
        return []
    }
}

extension Array {
    public func toData() -> Data? {
         do {
             let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
             return jsonData
         } catch {
             print(error.localizedDescription)
         }
         return nil
     }
}

