//
//  AllItemsTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/18/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

class AllItemsTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "\(AllItemsTableViewCell.self)"
    
    // MARK: Properties
    fileprivate let checkedImage = UIImage(named: "FavouritesChecked")! as UIImage
    fileprivate let uncheckedImage = UIImage(named: "FavouritesUnchecked")! as UIImage
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var buyButton: UIButton!
    @IBOutlet fileprivate weak var favoriteButton: UIButton!
    
    weak var delegate: FavoriteCellDelegate?
    fileprivate var request: Request?
    fileprivate var productID: Int?
    fileprivate var productName: String? {
        didSet { nameLabel.text = productName }
    }
    fileprivate var productPrice: Int? {
        didSet { priceLabel.text = "\(productPrice!) Coins" }
    }
    var favorite: Bool = false {
        didSet {
            favorite == true ? checked() : unchecked()
        }
    }
    
    @IBAction fileprivate func buyButtonPressed(_ sender: UIButton) {
        
        //Present confirmation message.
        print("buyButtonPressed")
        //        let navigation = NavigationManager.tabBarController?.selectedViewController as! UINavigationController
        //        let allProductController = navigation.visibleViewController as! AllProductsViewController
        //        allProductController.presentConfirmation(with: productID, name: productName, price: productPrice)
    }
    
    @IBAction fileprivate func favouritesButtonPressed(_ sender: UIButton) {
        
        favorite = !favorite
        guard let productID = productID, let productName = productName else { return }
        if favorite == true {
            delegate?.add(favorite: productID, name: productName)
        } else {
            delegate?.remove(favorite: productID, name: productName)
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        resetImage()
    }
    
    func configure(with item: Products) -> AllItemsTableViewCell {
        
        productID = item.internalIdentifier
        productName = item.name
        productPrice = item.price
        return self
    }
    
    fileprivate func checked() {
        
        favoriteButton.setImage(checkedImage, for: UIControlState())
    }
    
    fileprivate func unchecked() {
        
        favoriteButton.setImage(uncheckedImage, for: UIControlState())
    }
    
    fileprivate func resetImage() {
        request?.cancel()
        logo.image = UIImage(named: "Placeholder")
    }
}
