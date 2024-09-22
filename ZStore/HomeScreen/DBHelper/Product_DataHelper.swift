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

class Product_DataHelper
{
    
    static let shared = Product_DataHelper()
    
    public static func saveCategories(dbManager : DBManager,categories : [ProductCategory],completionHandler: @escaping(Result<Bool, Error>) -> Void){
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
    
    public static func saveOffers(dbManager : DBManager,cardOffers : [CardOffer],completionHandler: @escaping(Result<Bool, Error>) -> Void){
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
    
    
    public func saveProducts(dbManager : DBManager,products : [Product],completionHandler: @escaping(Result<Bool, Error>) -> Void){
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
                    dbObj.review_count = Int64(product.review_count ?? 0)
                    print(product.colors?.toData())
                    dbObj.colors = product.colors?.toData()
                    
                    if let _category = self.fetchCategoryById(product.id, context: managedContext){
                        dbObj.category = _category
                    }
                    
                    if let cardOfferIds = product.card_offer_ids{
                        if let _cardOffers = self.fetchCardOffersByIds(cardOfferIds, context: managedContext){
                            dbObj.addToCardOffers(_cardOffers)
                        }
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
    
    func fetchCategoryById(_ id : String,context : NSManagedObjectContext) -> CategoryData?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Category.rawValue)
        request.predicate = DBQueries.filterBy(categoryId: id)
        
        do {
            let categories = try context.fetch(request)
            return categories.first as? CategoryData
        } catch {
            print("Failed to fetch category: \(error)")
            return nil
        }
    }
    
    func fetchCardOffersByIds(_ ids: [String], context: NSManagedObjectContext) -> [CardOfferData]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.CardOffer.rawValue)
        request.predicate = DBQueries.filterBy(ids: ids)
        
        do {
            let cardOffers = try context.fetch(request)
            return cardOffers as? [CardOfferData]
        } catch {
            print("Failed to fetch card offers: \(error)")
            return nil
        }
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

