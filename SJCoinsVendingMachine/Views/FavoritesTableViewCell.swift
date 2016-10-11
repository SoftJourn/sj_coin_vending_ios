//
//  FavoritesTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "\(FavoritesTableViewCell.self)"

    // MARK: Properties
    @IBOutlet fileprivate weak var favouritesLogo: UIImageView!
    @IBOutlet fileprivate weak var favouritesNameLabel: UILabel!
    @IBOutlet fileprivate weak var favouritesPriceLabel: UILabel!
    
    fileprivate var request: Request?
    fileprivate var producName: String? {
        didSet { favouritesNameLabel.text = producName }
    }
    fileprivate var productPrice: Int? {
        didSet { favouritesPriceLabel.text = "\(productPrice!) Coins" }
    }

    func configure(with item: Products) -> FavoritesTableViewCell {
        
        producName = item.name
        productPrice = item.price
        loadImage(with: item.imageUrl)
        return self
    }
    
    fileprivate func loadImage(with endpoint: String?) {
        
        guard let endpoint = endpoint else { return favouritesLogo.image = UIImage(named: "Placeholder") }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            APIManager.fetch(image: endpoint) { image in
                self.favouritesLogo.image = image
            }
            return
        }
        self.favouritesLogo.image = cashedImage
    }
    
    fileprivate func resetImage() {
        request?.cancel()
        favouritesLogo.image = UIImage(named: "Placeholder")
    }
}
