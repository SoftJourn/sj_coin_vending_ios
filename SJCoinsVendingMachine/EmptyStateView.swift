//
//  EmptyStateView.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/9/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet weak var textLabel: UILabel!

    
    func setupView() {
        Bundle.main.loadNibNamed(EmptyStateView, owner: self, options: nil)
        view.frame = self.frame
        addSubview(view)
    }
    
}

