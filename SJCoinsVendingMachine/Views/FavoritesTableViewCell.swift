//
//  FavoritesTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire
import  SVProgressHUD

class FavoritesTableViewCell: BaseTableViewCell {
    
    // MARK: Constants
    static let identifier = "\(FavoritesTableViewCell.self)"
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {

        delegate?.buy(product: item)
    }
    // MARK: Actions
    @IBAction fileprivate func favoriteButtonPressed(_ sender: UIButton) {
    
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        favorite = !favorite
        favorite ? delegate?.add(favorite: self) : delegate?.remove(favorite: self)
    }

    // MARK: Methods
    func configure(with product: Products) -> FavoritesTableViewCell {
       
        item = product
        favorite = true
        if let name = product.name, let price = product.price {
            nameLabel.text = name
            priceLabel.text = "\(price) Coins"
        }
        load(image: product.imageUrl)
        return self
    }    
}
