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
    
    // MARK: Property
    var availability: Bool = true {
        didSet {
            availability ? available() : unvailable()
        }
    }
    
    @IBAction private func buyButtonPressed(_ sender: UIButton) {

        verifyConnection {
            delegate?.buy(product: item)
        }
    }
    
    // MARK: Actions
    @IBAction private func favoriteButtonPressed(_ sender: UIButton) {
    
        verifyConnection {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            favorite = !favorite
            favorite ? delegate?.add(favorite: self) : delegate?.remove(favorite: self)
        }
    }

    // MARK: Methods
    func configure(with product: Products) -> FavoritesTableViewCell {
       
        print("Product id \(product.name!, product.internalIdentifier!)")
        item = product
        favorite = true
        if let name = product.name, let price = product.price {
            nameLabel.text = name
            priceLabel.text = "\(price) Coins"
        }
        if let url = URL.init(string: "\(networking.baseURL)vending/v1/\(item.imageUrl)") {
            logo.af_setImage(withURL: url)
        }
        return self
    }
    
    private func available() {
        
        buyButton.isEnabled = true
        logo.alpha = 1
    }

    private func unvailable() {
       
        buyButton.isEnabled = false
        logo.alpha = 0.3
    }
}
