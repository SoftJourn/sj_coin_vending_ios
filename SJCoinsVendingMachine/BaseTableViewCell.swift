//
//  BaseTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BaseTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    

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
        logo.af_cancelImageRequest()
        logo.layer.removeAllAnimations()
        logo.image = nil
    }

    private func checked() {
        
        favoriteButton.setImage(#imageLiteral(resourceName: "checked"), for: UIControlState())
    }
    
    private func unchecked() {
        
        favoriteButton.setImage(#imageLiteral(resourceName: "unchecked"), for: UIControlState())
    }
    
    func verifyConnection(execute: ()->()) {
        
        !Reachability.connectedToNetwork() ? AlertManager().present(alert: errorMessage.reachability) : execute()
    }
}
