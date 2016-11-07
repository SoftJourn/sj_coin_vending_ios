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
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        resetImage()
    }
    
    func configure(with item: Products) -> HomeCollectionViewInternalCell {
        
        name = item.name
        price = item.price
        load(image: item.imageUrl)
        return self
    }
    
    private func resetImage() {
        
        request?.cancel()
        logo.image = picture.placeholder
    }
    
    private func load(image endpoint: String?) {
        
        guard let endpoint = endpoint else { return logo.image = picture.placeholder }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            APIManager.fetch(image: endpoint) { [unowned self] image in
                self.logo.image = image
            }
            return
        }
        return logo.image = cashedImage
    }
    
//    private func showImageAnimated(_ image: UIImage) {
//        
//        logo.image = image
//        logo.alpha = 0
//
//        UIView.animate(withDuration: 0, delay: 0.3, options: .curveEaseOut, animations: { () -> Void in
//            self.logo.alpha = 1
//            }, completion: nil)
//    }

    private func available() {
        
        logo.alpha = 1
    }
    
    private func unvailable() {
        
        logo.alpha = 0.3
    }
}
