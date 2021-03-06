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
    private let isEmptyString = "This field is required."
    private let emptyString = ""
    
    // MARK: Properties
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak private var imageLogo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var versionLabel: UILabel!
    
    @IBOutlet weak private var loginErrorLabel: UILabel!
    @IBOutlet weak private var passwordErrorLabel: UILabel!
    
    fileprivate var login: String {
        return self.loginTextField.text!
    }
    fileprivate var password: String {
        return self.passwordTexField.text!
    }
    private var loginValidation: validationStatus {
        return ValidationManager.validate(string: loginTextField.text!)
    }
    private var passwordValidation: validationStatus {
        return ValidationManager.validate(string: passwordTexField.text!)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTexField.delegate = self
        passwordTexField.returnKeyType = .done
        registerForKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        LoginPage.decorateLoginViewController(self)
        AnimationHelper().applyMotionEffect(toView: imageLogo, magnitude: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        loginErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        SVProgressHUD.dismiss(withDelay: 0.2)
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showElementsAnimated()
    }
    
    deinit {
        
        print("LoginViewController DELETED.")
    }
    
    // MARK: Actions
    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        
        loginValidation == .success && passwordValidation == .success ? authorization() : showError()
    }
    
    @IBAction private func loginTextFieldDidChange(_ sender: UITextField) {
        
        handle(validationResult: loginValidation, viaLabel: loginErrorLabel)
    }
    
    @IBAction private func passwordTextFieldDidChange(_ sender: UITextField) {
        
        handle(validationResult: passwordValidation, viaLabel: passwordErrorLabel)
    }
    
    //MARK: Animation methods.
    private func prepareAnimation() {
        
        loginTextField.alpha = 0
        passwordTexField.alpha = 0
        loginButton.alpha = 0
        versionLabel.alpha = 0
    }
    
    private func showElementsAnimated() {
        
        let animator = AnimationHelper()
        animator.showScaled(imageLogo)
        animator.showHidden(loginTextField, delay: 0.2)
        animator.showHidden(passwordTexField, delay: 0.4)
        animator.showHidden(loginButton, delay: 0.8)
        animator.showHidden(versionLabel, delay: 1)
    }
    
    //MARK: Validation methods.
    private func showError() {
        
        if loginTextField.text?.isEmpty == true {
            handle(validationResult: .isEmpty, viaLabel: loginErrorLabel)
        }
        if passwordTexField.text?.isEmpty == true {
            handle(validationResult: .isEmpty, viaLabel: passwordErrorLabel)
        }
    }
    
    private func handle(validationResult result: validationStatus, viaLabel label: UILabel) {
        
        func config(_ label: UILabel, text: String, isHidden: Bool) {
            
            label.text = text
            label.isHidden = isHidden
        }
        
        switch result {
        case .isEmpty:
            config(label, text: isEmptyString, isHidden: false)
        case .success:
            config(label, text: emptyString, isHidden: true)
        }
    }
    
    // MARK: Authorization methods.
    private func authorization() {
       
        connectionVerification {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            AuthorizationManager.authRequest(login: login, password: password) { [unowned self] error in
                error != nil ? self.authFailed() : self.authSuccess()
            }
        }
    }
    
    private func authSuccess() {
  
        DataManager.shared.launchedBefore && DataManager.shared.chosenMachine != nil ? regularLaunching() : firstLaunching()
    }
    
    private func authFailed() {
        
        SVProgressHUD.dismiss()
        present(alert: .authorization)
    }
    
    private func firstLaunching() {
        
        firstly {
            fetchDefaultMachine()
        }.then { _ in
            DataManager.shared.chosenMachine != nil ? self.fetchWithProducts() : self.fetchWithOutProducts()
        }.catch { _ in
            let actions = AlertManager().alertActions(cancel: true) {
                self.firstLaunching()
            }
            self.present(alert: .retryLaunch(actions))
        }
    }
    
    private func fetchWithOutProducts() {
        
        firstly {
            fetchFavorites()
        }.then { _ in
            self.fetchAccount()
        }.then { _ in
            NavigationManager.shared.presentTabBarController()
        }.catch { _ in
            let actions = AlertManager().alertActions(cancel: true) {
                self.fetchWithOutProducts()
            }
            self.present(alert: .retryLaunch(actions))
        }
    }
    
    private func fetchWithProducts() {
        
        firstly {
            fetchFavorites()
        }.then { _ in
            self.fetchProducts()
        }.then { _ in
            self.fetchAccount()
        }.then { _ in
            NavigationManager.shared.presentTabBarController()
        }.catch { _ in
            let actions = AlertManager().alertActions(cancel: true) {
                self.fetchWithProducts()
            }
            self.present(alert: .retryLaunch(actions))
        }
    }

    // MARK: ScrollView contentOffset
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .keyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .keyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWasShown(_ notification: Notification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    // MARK: UITapGestureRecognizer
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return string == " " ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == loginTextField {
            passwordTexField.becomeFirstResponder()
        }
        if textField == passwordTexField {
            passwordTexField.resignFirstResponder()
        }
        return true
    }
}
