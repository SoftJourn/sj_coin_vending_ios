//
//  CustomLoginUIButton.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/30/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

import UIKit

class CustomLoginUIButton: UIButton {
    
    // MARK: Constants
    private let r = 33
    private let g = 150
    private let b = 243
    
    // MARK: Properties
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? highlight() : clearHighlight()
        }
    }
    
    // MARK: Methods
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.applyCustomDesign()
    }
    
    func applyCustomDesign() {
        
        // Set the background color of the UIButton.
        clearHighlight()
    }
    
    func highlight() {
        
        backgroundColor = UIColor(red: r, green: g, blue: b).withAlphaComponent(0.7)
    }
    
    func clearHighlight() {
        
        backgroundColor = UIColor(red: r, green: g, blue: b).withAlphaComponent(1)
    }
}
