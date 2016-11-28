//
//  HomeCollectionViewInternalCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AlamofireImage

class HomeCollectionViewInternalCell: UICollectionViewCell {
   
    // MARK: Constants
    static let identifier = "\(HomeCollectionViewInternalCell.self)"

    // MARK: Properties
    @IBOutlet weak var logo: UIImageView!
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
    var availability: Bool = true {
        didSet {
            availability ? available() : unvailable()
        }
    }

    // MARK: Methods
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        logo.af_cancelImageRequest()
        logo.layer.removeAllAnimations()
        logo.image = nil
    }
    
    func configure(with item: Products) -> HomeCollectionViewInternalCell {
        
        name = item.name
        price = item.price
        
        guard let imageUrl = item.imageUrl else { return self }
        logo.af_setImage(withURL: URL(string: "\(networking.baseURL)vending/v1/\(imageUrl)")!,
                         placeholderImage: #imageLiteral(resourceName: "Placeholder"),
                         imageTransition: .crossDissolve(0.5))
        return self
    }
    
    private func available() {
        
        logo.alpha = 1
    }
    
    private func unvailable() {
        
        logo.alpha = 0.3
    }
}
