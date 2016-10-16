//
//  PurchaseHistoryTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/1/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class PurchaseHistoryTableViewCell: UITableViewCell {
    
    // MARK: Constants
    static let identifier = "\(PurchaseHistoryTableViewCell.self)"

    // MARK: Properties
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionItem: UILabel!
    @IBOutlet weak var transactionPrice: UILabel!

    override func prepareForReuse() {
        
        super.prepareForReuse()
        transactionDate.text = ""
        transactionItem.text = ""
        transactionPrice.text = ""
        //resetImage()
    }
    
//    func configure(with item: Products) -> AllItemsTableViewCell {
//        
//        transactionDate = item.internalIdentifier
//        transactionItem = item.name
//        transactionPrice = item.price
//        return self
//    }
}
