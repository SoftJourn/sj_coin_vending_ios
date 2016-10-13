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
        //configureLogo(viewController.imageLogo)
        configureLoginButton(viewController.loginButton)
    }
    
//    fileprivate class func configureUITextField(_ texfield: UITextField) {
//        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0.0, y: texfield.frame.height - 1.0, width: texfield.frame.width, height: 0.5)
//        bottomLine.backgroundColor = UIColor.black.cgColor
//        texfield.borderStyle = UITextBorderStyle.none
//        texfield.layer.addSublayer(bottomLine)
//    }
    
    fileprivate class func configureUITextField(_ texfield: UITextField) {
        
        //texfield.backgroundColor = UIColor.clear
        texfield.layer.cornerRadius = 5
        texfield.layer.borderWidth = 0.5
        texfield.layer.borderColor = UIColor.darkGray.cgColor
    }

//    fileprivate class func configureLogo(_ image: UIImageView) {
//        
//        image.layer.cornerRadius = image.frame.size.height/2
//        image.clipsToBounds = true
//    }
    
    fileprivate class func configureLoginButton(_ button: UIButton) {
    
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
    }
}
