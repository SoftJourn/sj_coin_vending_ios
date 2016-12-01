//
//  LoginPage.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class LoginPage: NSObject {

    class func decorateLoginViewController(_ viewController: LoginViewController) {

        configureUITextField(viewController.loginTextField)
        configureUITextField(viewController.passwordTexField)
        configureLoginButton(viewController.loginButton)
    }
    
    private class func configureUITextField(_ texfield: UITextField) {
        
        texfield.layer.cornerRadius = 5
        texfield.layer.borderWidth = 0.2
        texfield.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private class func configureLoginButton(_ button: UIButton) {
    
        button.layer.cornerRadius = 5
    }
}
