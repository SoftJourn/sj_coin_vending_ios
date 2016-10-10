//
//  HomeCollectionViewInternalCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

class HomeCollectionViewInternalCell: UICollectionViewCell {
   
    // MARK: Constants
    static let identifier = "\(HomeCollectionViewInternalCell.self)"

    // MARK: Properties
    @IBOutlet fileprivate weak var logo: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    fileprivate var request: Request?

    fileprivate var name: String? {
        didSet {
            if let name = name {
                nameLabel.text = name
            }
        }
    }
    
    fileprivate var price: Int? {
        didSet {
            if let price = price {
                priceLabel.text = "\(price) Coins"
            }
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        resetImage()
    }
    
    func configure(with item: Product) -> UICollectionViewCell {
        
        name = item.name()
        price = item.price()
        loadImage(with: item.imageEndpoint())
        return self
    }

    fileprivate func loadImage(with endpoint: String?) {
        
        guard let endpoint = endpoint else { return logo.image = UIImage(named: "Placeholder") }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            APIManager.fetch(image: endpoint) { image in
                self.logo.image = image
            }
            return
        }
        self.logo.image = cashedImage
    }
    
    fileprivate func resetImage() {
        request?.cancel()
        logo.image = UIImage(named: "Placeholder")
    }
}
