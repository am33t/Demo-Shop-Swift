//
//  ATTilesVC.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 07/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import UIKit

class ATTilesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    
    let cellWidth:CGFloat = 130
    let cellMargin:CGFloat = 25
    
    @IBOutlet var collectionView: UICollectionView!
    var items: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchItems()
        NotificationCenter.default.addObserver(self, selector: #selector(demoDataUpdated(notification:)), name: NSNotification.Name(kNotificationDemoDataUpdated), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        for _ in (0..<10) {
            self.items.append("MobCast")
        }
    }
    
    enum PageType {
        case products
        case categories
        case rankings
    }
    var pageType: PageType!
    var parenCategoryId: String!
    var parentRankingName: String!
    
    public func setDataParameters(_ pageType: PageType, parenCategoryId: String!, parentRankingName: String!) {
        self.pageType = pageType
        self.parenCategoryId = parenCategoryId
        self.parentRankingName = parentRankingName
    }
    
    private func fetchItems() {
        if self.pageType == PageType.categories {
            if self.parenCategoryId != nil {
                self.items = ATPersistenceManager.sharedManager().childCategoriesForCategoryId(self.parenCategoryId)
                }
            else {
                self.items = ATPersistenceManager.sharedManager().allCategories()
            }
        }
        else if self.pageType == PageType.products && self.parenCategoryId != nil {
            self.items = ATPersistenceManager.sharedManager().productsForCategoryId(self.parenCategoryId)
        }
        else if self.pageType == PageType.products && self.parentRankingName != nil {
            self.items = ATPersistenceManager.sharedManager().productsForRankingName(self.parentRankingName)
        }
        else if self.pageType == PageType.rankings {
            self.items = ATPersistenceManager.sharedManager().allRankings()
        }
    }

    @objc func demoDataUpdated(notification: Notification){
        self.fetchItems()
        self.collectionView.reloadData()
    }
    private func pushToNextPageForItem(_ item:Any) {
        if let category = item as? Category {
            self.pushForCategory(category)
        }
        else if let ranking = item as? Ranking {
            self.pushForRanking(ranking)
        }
        else if let product = item as? Product {
            self.pushForProduct(product)
        }
    }
    
    private func pushForCategory(_ category:Category) {
        if category.child_categories.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tilesVC = storyboard.instantiateViewController(withIdentifier: "ATTilesVC") as! ATTilesVC
            tilesVC.setDataParameters(.categories, parenCategoryId: category.id, parentRankingName: nil)
            tilesVC.navigationItem.title = category.name
            self.navigationController?.pushViewController(tilesVC, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tilesVC = storyboard.instantiateViewController(withIdentifier: "ATTilesVC") as! ATTilesVC
            tilesVC.setDataParameters(.products, parenCategoryId: category.id, parentRankingName: nil)
            tilesVC.navigationItem.title = category.name
            self.navigationController?.pushViewController(tilesVC, animated: true)
        }
    }
    
    private func pushForRanking(_ ranking:Ranking) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tilesVC = storyboard.instantiateViewController(withIdentifier: "ATTilesVC") as! ATTilesVC
        tilesVC.setDataParameters(.products, parenCategoryId: nil, parentRankingName: ranking.name)
        tilesVC.navigationItem.title = ranking.name
        self.navigationController?.pushViewController(tilesVC, animated: true)
    }
    
    private func pushForProduct(_ product:Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ATProductDetailVC") as! ATProductDetailVC
        productDetailVC.product = product
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ATTilesVC_Tile", for: indexPath) as! ATTilesVC_Tile
        cell.setItem(self.items[indexPath.row])
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells = Int(collectionView.bounds.size.width) / Int(cellWidth + cellMargin)
        let newWidth = (collectionView.bounds.size.width - CGFloat(cellMargin * CGFloat(numberOfCells + 1))) / CGFloat(numberOfCells)
        return CGSize(width: newWidth, height: newWidth)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.cellMargin, left: self.cellMargin, bottom: self.cellMargin, right: self.cellMargin)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellMargin
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellMargin
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.pushToNextPageForItem(item)
    }
}


class ATTilesVC_Tile: UICollectionViewCell {
   
    @IBOutlet var lblName: UILabel!
    @IBOutlet var vwBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwBackground.layer.cornerRadius = 15
        self.backgroundColor = UIColor.clear
    }
    func setItem(_ item:Any) {
        if let category = item as? Category {
            self.lblName.text = category.name
            if category.child_categories.count > 0 {
                self.vwBackground.backgroundColor = UIColor(displayP3Red: 71.0/255.0, green: 172.0/255.0, blue: 106.0/255.0, alpha: 1)
            }
            else {
                self.vwBackground.backgroundColor = UIColor(displayP3Red: 50.0/255.0, green: 160.0/255.0, blue: 209.0/255.0, alpha: 1)
            }
        }
        else if let product = item as? Product {
            self.lblName.text = product.name
            self.vwBackground.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 109.0/255.0, blue: 109.0/255.0, alpha: 1)
        }
        else if let product = item as? Ranking {
            self.lblName.text = product.name
            self.vwBackground.backgroundColor = UIColor(displayP3Red: 67.0/255.0, green: 168.0/255.0, blue: 182.0/255.0, alpha: 1)
        }
    }
}
