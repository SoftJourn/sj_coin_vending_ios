//
//  AllItemsTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/18/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AllItemsTableViewCell: BaseTableViewCell {
    
    // MARK: Constants
    static let identifier = "\(AllItemsTableViewCell.self)"
        
    // MARK: Actions
    @IBAction fileprivate func buyButtonPressed(_ sender: UIButton) {
        
        delegate?.buy(product: item)
    }
    
    @IBAction fileprivate func favouritesButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        favorite = !favorite
        favorite ? delegate?.add(favorite: self) : delegate?.remove(favorite: self)
    }
    
    // MARK: Methods
    func configure(with product: Products) -> AllItemsTableViewCell {
        
        //print("Product id \(product.internalIdentifier!)")
        item = product
        if let name = product.name, let price = product.price {
            nameLabel.text = name
            priceLabel.text = "\(price) Coins"
        }
        load(image: product.imageUrl)
        return self
    }
}
