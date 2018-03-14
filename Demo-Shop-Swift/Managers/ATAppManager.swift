//
//  ATAppManager.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 06/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import Foundation
public let kNotificationDemoDataUpdated = "kNotificationDemoDataUpdated"
class ATAppManager
{
    private static var sharedManagerObject: ATAppManager = {
        let sharedManagerObject = ATAppManager()
        return sharedManagerObject
    }()
    
    class func sharedManager() -> ATAppManager {
        return sharedManagerObject
    }
    
    func refreshDemoData() {
        ATAPIManager.sharedManager().getData { (data) in
            var obCategories = [Category]()
            let dictionary = data;
            if let categories : Array = dictionary["categories"] as? Array<[String:Any]> {
                for category in categories {
                    let obCategory = Category()
                    obCategories.append(obCategory)
                    if let id = category["id"] as? Double {
                       obCategory.id = "\(Int(id))"
                    }
                    if let name = category["name"] as? String {
                        obCategory.name = name
                    }
                    if let products = category["products"] as? Array<[String:Any]> {
                        for product in products {
                            let obProduct = Product()
                            obCategory.products.append(obProduct)
                            if let id = product["id"] as? Double {
                                obProduct.id = "\(Int(id))"
                            }
                            if let name = product["name"] as? String {
                                obProduct.name = name
                            }
                            if let date_added = product["date_added"] as? String {
                                obProduct.date_added = date_added;
                            }
                            
                            if let variants = product["variants"] as? Array<[String:Any]> {
                                for variant in variants {
                                    let obVariant = Variant()
                                    obProduct.variants.append(obVariant)
                                    if let id = variant["id"] as? Double {
                                        obVariant.id = "\(Int(id))"
                                    }
                                    if let color = variant["color"] as? String {
                                        obVariant.color = color
                                    }
                                    if let size = variant["size"] as? Double {
                                        obVariant.size = "\(Int(size))"
                                    }
                                    if let price = variant["price"] as? Double {
                                        obVariant.price = "\(Int(price))"
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    if let child_categories = category["child_categories"] as? Array<Double> {
                        for child_category in child_categories {
                            obCategory.child_categories.append("\(Int(child_category))")
                        }
                    }
                }
            }
            var obRankings = [Ranking]()
            if let rankings = dictionary["rankings"] as? Array<[String:Any]> {
                for ranking in rankings {
                    let obRanking = Ranking()
                    obRankings.append(obRanking)
                    if let name = ranking["ranking"] as? String {
                        obRanking.name = name
                    }
                    if let products = ranking["products"] as? Array<[String:Any]> {
                        for product in products {
                            if let id = product["id"] as? Double {
                                if let product = ATPersistenceManager.sharedManager().productWithId("\(Int(id))") {
                                    obRanking.products.append(product)
                                }
                            }
                        }
                    }
                }
            }
            ATPersistenceManager.sharedManager().insertCategories(obCategories)
            ATPersistenceManager.sharedManager().insertRankings(obRankings)
            NotificationCenter.default.post(name: NSNotification.Name(kNotificationDemoDataUpdated), object:nil)
        }
            
        
        
    }
}
