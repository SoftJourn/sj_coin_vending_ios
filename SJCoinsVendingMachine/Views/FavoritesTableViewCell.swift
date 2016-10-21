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

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "\(FavoritesTableViewCell.self)"

    // MARK: Properties
    @IBOutlet weak var favouritesLogo: UIImageView!
    @IBOutlet fileprivate weak var favouritesNameLabel: UILabel!
    @IBOutlet fileprivate weak var favouritesPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: CellDelegate?
    fileprivate var request: Request?
    fileprivate var productID: Int?
    fileprivate var producName: String? {
        didSet { favouritesNameLabel.text = producName }
    }
    fileprivate var productPrice: Int? {
        didSet { favouritesPriceLabel.text = "\(productPrice!) Coins" }
    }
    var favorite: Bool = true {
        didSet {
            favorite ? checked() : unchecked()
        }
    }
    var savedItem: Products?
    var indexPath: IndexPath?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        favouritesNameLabel.text = ""
        favouritesPriceLabel.text = ""
        resetImage()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
    
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        favorite = !favorite
        guard let item = savedItem, let index = indexPath else { return }
        if favorite {
            delegate?.add(favorite: item, index: index)
        } else {
            delegate?.remove(favorite: item)
        }
    }

    func configure(with item: Products, index: IndexPath) -> FavoritesTableViewCell {
       
        indexPath = index
        savedItem = item
        favorite = true
        productID = item.internalIdentifier
        producName = item.name
        productPrice = item.price
        load(image: item.imageUrl)
        return self
    }
    
    fileprivate func resetImage() {
        
        request?.cancel()
        favouritesLogo.image = UIImage(named: "Placeholder")
    }
    
    func load(image endpoint: String?) {
        
        guard let endpoint = endpoint else { return favouritesLogo.image = UIImage(named: "Placeholder") }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            return APIManager.fetch(image: endpoint) { [unowned self] image in
                self.favouritesLogo.image = image
            }
        }
        favouritesLogo.image = cashedImage
    }
    
    fileprivate func checked() {
        
        favoriteButton.setImage(favoriteImage.checked, for: UIControlState())
    }
    
    fileprivate func unchecked() {
        
        favoriteButton.setImage(favoriteImage.unchecked, for: UIControlState())
    }
}
