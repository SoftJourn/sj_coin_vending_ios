//
//  SJCProductsViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/9/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import SwiftyUserDefaults

class HomeViewController: BaseViewController {
    
    // MARK: Constants
    let cellHeight: CGFloat = 180
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    fileprivate var categories: [Categories]? {
        
        return DataManager.shared.preparedCategories()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchMachinesFirstTime()
        collectionView.addSubview(refreshControl)
        fetchContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
    }
    
    deinit {
        
        print("HomeViewController deinited")
    }
    
    // MARK: Actions
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show(withStatus: spinerMessage.downloading)
        fetchMachines { _ in
            NavigationManager.shared.presentSettingsViewController()
        }
    }
    
    @IBAction func refreshTokenTest(_ sender: UIBarButtonItem) {
        
        AuthorizationManager.refreshRequest { model, error in
            guard model != nil else { return print(error?.localizedDescription) }
            AuthorizationManager.save(authInfo: model!)
        }
    }
    
    // MARK: Set default vending machnine when app launched first time.
    fileprivate func fetchMachinesFirstTime() {
        
        if Defaults[.fistLaunch] {

            fetchMachines { [unowned self] object in
                
                let machines = object as! [MachinesModel]
                guard let id = machines[0].internalIdentifier else { return }
                AuthorizationManager.save(machineId: id)
                Defaults[.fistLaunch] = false
                self.fetchContent()
            }
        }
    }
    
    fileprivate func fetchMachines(complition: @escaping (_ object: AnyObject)->()) {
        
        firstly {
            APIManager.fetchMachines()
        }.then { object -> Void in
            DataManager.shared.save(object)
            complition(object)
        }.catch { error in
            SVProgressHUD.dismiss()
            AlertManager().present(retryAlert: errorTitle.download, message: errorMessage.retryDownload, actions: self.retryActions())
        }
    }
    
    fileprivate func retryActions() -> [UIAlertAction] {
        
        let confirmButton = UIAlertAction(title: buttonTitle.retry , style: .destructive) { [unowned self] action in
            self.fetchMachines { _ in }
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return [confirmButton, cancelButton]
    }

    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchProducts()
        fetchAccount()
        fetchFavorites()
        refreshControl.endRefreshing()
    }
    
    override func updateProducts() {
        
        SVProgressHUD.dismiss()
        updateCollectionView()
    }
    
    override func updateAccount() {
        
        updateBalance()
    }
    
    fileprivate func updateCollectionView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func updateBalance() {
        
        guard let balance = DataManager.shared.balance() else { return /* show */ }
        
        DispatchQueue.main.async { [unowned self] in
            self.balanceLabel.text = "Your balance is \(balance) coins"
        }
    }
    
    override func updateUIafterBuying() {
        
        updateBalance()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories == nil ? 0 : categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        guard let categories = categories?[indexPath.item], let products = categories.products else { return cell }
        if !products.isEmpty {
            cell.delegate = self
            return cell.configure(with: categories)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
}

extension HomeViewController: CellDelegate {
    
    // MARK: CellDelegate
    func buy(product identifier: Int, name: String, price: Int) {
        
        confirmation(identifier, name: name, price: price)
    }
}
