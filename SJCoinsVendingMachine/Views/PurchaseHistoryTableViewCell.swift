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
}
