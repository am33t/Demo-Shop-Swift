//
//  ATProductDetailVC.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 13/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import UIKit

class ATProductDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var tableViewVariants: UITableView!
    var product: Product?
    var selectedInvexVariant:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.tableViewVariants.rowHeight = UITableView.automaticDimension
        self.tableViewVariants.estimatedRowHeight = 100
        self.tableViewVariants.dataSource = self
        self.tableViewVariants.delegate = self
        
        self.lblTitle.text = product?.name
        self.tableViewVariants.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product?.variants.count ?? 0
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableViewVariants.dequeueReusableCell(withIdentifier: "ATProductDetailVC_VariantCall") as? ATProductDetailVC_VariantCall {
            let variant = self.product?.variants[indexPath.row]
            var text = ""
            if let price = variant?.price {
                text.append("Price: \(price)₹ ")
            }
            if let color = variant?.color {
                text.append("Color: \(color) ")
            }
            if let size = variant?.size {
                text.append("Size: \(size) ")
            }
            cell.lblTitle.text = text
            if let selectedInvexVariant = self.selectedInvexVariant, indexPath == selectedInvexVariant {
                cell.vwBackground.backgroundColor = UIColor(red: 0.5, green: 0.4, blue: 0.5, alpha: 1)
            }
            else {
                cell.vwBackground.backgroundColor = UIColor.gray
            }
            return cell
        }
        return UITableViewCell.init()

    }
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedInvexVariant = indexPath
        self.tableViewVariants.reloadData()
    }
    

}

class ATProductDetailVC_VariantCall: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var vwBackground:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwBackground.layer.cornerRadius = 5
        self.vwBackground.layer.masksToBounds = true
    }
}
