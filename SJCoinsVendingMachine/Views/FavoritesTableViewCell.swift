//
//  FavoritesTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage

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
            delegate?.remove(favorite: self)
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
        
        guard let imageUrl = item.imageUrl else { return self }
        logo.af_setImage(withURL: URL(string: "\(networking.baseURL)vending/v1/\(imageUrl)")!,
                         placeholderImage: #imageLiteral(resourceName: "Placeholder"),
                         imageTransition: .crossDissolve(0.5))
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
