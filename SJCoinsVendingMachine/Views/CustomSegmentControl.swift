//
//  CustomSegmentControl.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/23/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class CustomSegmentControl: UISegmentedControl {

    var oldValue: Int!
    
    //Capture existing selected segment on touchBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.oldValue = self.selectedSegmentIndex
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        if self.oldValue == self.selectedSegmentIndex {
            sendActions( for: .valueChanged)
        }
    }
}
