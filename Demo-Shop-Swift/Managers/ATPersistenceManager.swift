//
//  ATPersistenceManager.swift
//  HeadyDemoSwift
//
//  Created by MobCast Innovations on 01/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: Model
final class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    let products = List<Product>()
    let child_categories = List<String>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Product: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var date_added = ""
    let variants = List<Variant>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
final class Variant: Object {
    @objc dynamic var color = ""
    @objc dynamic var id = ""
    @objc dynamic var size = ""
    @objc dynamic var price = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
final class Ranking: Object {
    @objc dynamic var name = ""
    let products = List<Product>()
    override static func primaryKey() -> String? {
        return "name"
    }
}

class ATPersistenceManager
{
    private static var sharedManagerObject: ATPersistenceManager = {
        let sharedManagerObject = ATPersistenceManager()
        return sharedManagerObject
    }()
    
    class func sharedManager() -> ATPersistenceManager {
        return sharedManagerObject
    }
    
    func insertCategories(_ categories:[Category]) {
        let realm = try! Realm()
        for category in categories {
            try! realm.write {
                realm.add(category, update: .all)
            }
        }
    }
    func insertRankings(_ rankings:[Ranking]) {
        let realm = try! Realm()
        for ranking in rankings {
            try! realm.write {
                realm.add(ranking, update: .all)
            }
        }
    }
    func productWithId(_ id:String) -> Product? {
        let realm = try! Realm()
        let product = realm.objects(Product.self).filter("id = '\(id)'").first
        return product
    }
    func allCategories() -> [Category] {
        let realm = try! Realm()
        let objects = realm.objects(Category.self)
        return Array(objects)
    }
    func allRankings() -> [Ranking] {
        let realm = try! Realm()
        let objects = realm.objects(Ranking.self)
        return Array(objects)
    }
    func childCategoriesForCategoryId(_ categoryId:String) -> [Category] {
        let realm = try! Realm()
        if let category = realm.objects(Category.self).filter("id = '\(categoryId)'").first {
            let categories = realm.objects(Category.self).filter("id IN %@",category.child_categories)
            return Array(categories)
        }
        return [Category]()
    }
    func productsForCategoryId(_ categoryId:String) -> [Product] {
        let realm = try! Realm()
        let category = realm.objects(Category.self).filter("id = '\(categoryId)'").first
        return Array(category!.products)
    }
    func productsForRankingName(_ rankingName:String) -> [Product] {
        let realm = try! Realm()
        let ranking = realm.objects(Ranking.self).filter("name = '\(rankingName)'").first
        return Array(ranking!.products)
    }
}
