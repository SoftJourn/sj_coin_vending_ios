//
//  LoginViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/4/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class LoginViewController: BaseViewController {
    
    // MARK: Constants
    static let identifier = "\(LoginViewController.self)"
    
    // MARK: Properties
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak private var imageLogo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    fileprivate var login: String {
        return self.loginTextField.text!
    }
    fileprivate var password: String {
        return self.passwordTexField.text!
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        LoginPage.decorateLoginViewController(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    deinit {
        
        print("LoginViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        
        let validation = ValidationManager.validate(login: login, password: password)
        validation ? present(alert: .validation) : authorization()
    }
    
    private func authorization() {
       
        connectionVerification {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            AuthorizationManager.authRequest(login: login, password: password) { [unowned self] error in
                error != nil ? self.authFailed() : self.authSuccess()
            }
        }
    }
    
    private func authSuccess() {
  
        if DataManager.shared.fistLaunch {
            firstly {
                self.fetchDefaultMachine().asVoid()
            }.then {
                self.fetchFavorites().asVoid()
            }.then {
                self.fetchProducts().asVoid()
            }.then {
                self.fetchAccount().asVoid()
            }.then {
                NavigationManager.shared.presentTabBarController()
            }
        } else {
            firstly {
                self.fetchFavorites().asVoid()
            }.then {
                self.fetchProducts().asVoid()
            }.then {
                self.fetchAccount().asVoid()
            }.then {
                NavigationManager.shared.presentTabBarController()
            }
        }
    }
    
    private func authFailed() {
        
        present(alert: .authorization)
    }
    
    // MARK: ScrollView contentOffset
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .keyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .keyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWasShown(_ notification: Notification) {
        
        let info: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: CGRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        let loginButtonFrame: CGRect = self.view.convert(self.loginButton.frame, from: nil)
        let coveredFrame: CGRect = loginButtonFrame.intersection(keyboardFrame)
        scrollView.setContentOffset(CGPoint(x: 0, y: coveredFrame.height + 130), animated: true)
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension LoginViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
