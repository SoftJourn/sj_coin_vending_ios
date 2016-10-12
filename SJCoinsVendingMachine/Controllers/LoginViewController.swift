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
        
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.dismiss()
    }
    
    deinit {
        print("LoginViewController deinited")
    }
    
    // MARK: Actions
    @IBAction fileprivate func signInButtonPressed(_ sender: UIButton) {
        
        let validation = ValidationManager.validate(login: login, password: password)
        validation ? present(errorType.validation) : authorization()
    }
    
    fileprivate func authorization() {
        
        SVProgressHUD.show(withStatus: sign.inMessage)
        AuthorizationManager.authRequest(login: login, password: password) { [unowned self] error in
            error != nil ? self.authFailed(error!) : self.authSuccess()
        }
    }
    
    fileprivate func authSuccess() {
        
        //Fetch machines list
        firstly {
            APIManager.fetchMachines()
        }.then { object -> Void in
            DataManager.shared.save(object)
            NavigationManager.shared.presentMachinesViewController()
        }.catch { error in
             print(error)
             //SVProgressHUD.dismiss()
             //AlertManager().present(retryAlert: errorTitle.download, message: errorMessage.retryDownload, action: self.predefinedAction())
        }
        
    }
    
    fileprivate func authFailed(_ error: Error) {
        
        self.present(errorType.authorization(error))
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
