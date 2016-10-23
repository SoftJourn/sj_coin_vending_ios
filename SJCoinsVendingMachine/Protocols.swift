//
//  Protocols.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/21/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    
    func add(favorite cell: BaseTableViewCell)
    func remove(favorite cell: BaseTableViewCell)
    func buy(product item: Products)
}
