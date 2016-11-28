//
//  CustomSegmentControl.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/23/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class CustomSegmentControl: UISegmentedControl {

    private var oldValue: Int!
    
    //Capture existing selected segment on touchBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        oldValue = selectedSegmentIndex
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        if oldValue == selectedSegmentIndex {
            sendActions(for: .touchUpInside)
        }
    }
}
