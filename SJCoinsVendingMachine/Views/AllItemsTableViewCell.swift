//
//  AllItemsTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/18/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class AllItemsTableViewCell: BaseTableViewCell {
    
    // MARK: Constants
    static let identifier = "\(AllItemsTableViewCell.self)"
    
    // MARK: Actions
    @IBAction private func buyButtonPressed(_ sender: UIButton) {
        
        verifyConnection {
            delegate?.buy(product: item)
        }
    }
    
    @IBAction private func favouritesButtonPressed(_ sender: UIButton) {
        
        verifyConnection {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            favorite ? delegate?.remove(favorite: self) : delegate?.add(favorite: self)
        }
    }
    
    // MARK: Methods
    func configure(with product: Products) -> AllItemsTableViewCell {
        
        print("Product id \(product.name!, product.internalIdentifier!)")
        item = product
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
}
