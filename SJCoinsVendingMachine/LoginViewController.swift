//
//  LoginViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/4/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: Constants
    static let identifier = "\(LoginViewController.self)"
    let logInMessage = "Signing in ..."
    
    // MARK: Properties
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate var login: String {
        return self.loginTextField.text!
    }
    fileprivate var password: String {
        return self.passwordTexField.text!
    }
    
    // MARK: Life cycle
    override internal func viewDidLoad() {
        
        super.viewDidLoad()
        registerForKeyboardNotifications()
        //LoginPage.decorateLoginViewController(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Navigation.shared.visibleViewController = self
        SVProgressHUD.dismiss()
    }
    
    // MARK: Actions
    @IBAction fileprivate func signInButtonPressed(_ sender: UIButton) {
        
        let validation = ValidationManager.validate(login: login, password: password)
        !validation ? present(errorType.validation) : authorization()
    }
    
    fileprivate func authorization() {
        
        SVProgressHUD.show(withStatus: logInMessage)
        AuthorizationManager.authRequest(login: login, password: password) { [unowned self] error in
            SVProgressHUD.dismiss()
            error != nil ? self.present(errorType.authorization(error!)) : Navigation.shared.presentTabBarController()
        }
    }
    // перенести в бесй контроллер
    enum errorType {
        case validation
        case authorization(Error)
    }
    
    fileprivate func present(_ error: errorType) {
        
        switch error {
        case validation:
            SVProgressHUD.dismiss()
            //FIXME: Create alertManager
            //let alertController = UIAlertController.presentAlert(with: errorTitle.validation, message: errorMessage.validation)
        //present(alertController, animated: true) { }
        case .authorization(let error): break
            //FIXME: Create alertManager
            //If error present display it.
            //let alertController = UIAlertController.presentAlert(with: errorTitle.auth, message: error.localizedDescription)
            //self.present(alertController, animated: true) { }
        }
    }
    
    // MARK: ScrollView contentOffset
    fileprivate func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func keyboardWasShown(_ notification: Notification) {
        
        let info: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: CGRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        let loginButtonFrame: CGRect = self.view.convert(self.loginButton.frame, from: nil)
        let coveredFrame: CGRect = loginButtonFrame.intersection(keyboardFrame)
        scrollView.setContentOffset(CGPoint(x: 0, y: coveredFrame.height + 180), animated: true)
    }
    
    @objc fileprivate func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}
