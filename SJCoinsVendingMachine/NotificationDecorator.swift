//
//  NotificationDecorator.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/15/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let machineChanged = Notification.Name("machineChanged")
    static let keyboardDidShow = NSNotification.Name.UIKeyboardDidShow
    static let keyboardWillHide = NSNotification.Name.UIKeyboardWillHide
}
