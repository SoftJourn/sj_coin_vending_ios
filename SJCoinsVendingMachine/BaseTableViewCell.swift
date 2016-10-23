//
//  BaseTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    weak var delegate: CellDelegate?
    var request: Request?
    var item: Products!
    var favorite: Bool = false {
        didSet {
            favorite ? checked() : unchecked()
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        resetImage()
    }

    fileprivate func checked() {
        
        favoriteButton.setImage(picture.checked, for: UIControlState())
    }
    
    fileprivate func unchecked() {
        
        favoriteButton.setImage(picture.unchecked, for: UIControlState())
    }
    
    func resetImage() {
        
        request?.cancel()
        logo.image = picture.placeholder
    }
    
    func load(image endpoint: String?) {
        
        guard let endpoint = endpoint else { return logo.image = picture.placeholder }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            return APIManager.fetch(image: endpoint) { [unowned self] image in
                self.logo.image = image
            }
        }
        logo.image = cashedImage
    }
}
