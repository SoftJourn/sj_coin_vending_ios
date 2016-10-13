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

class HomeViewController: BaseViewController {
    
    // MARK: Constants
    let cellHeight: CGFloat = 180
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    fileprivate var categories: [Categories]? {
        return DataManager.shared.category()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.addSubview(refreshControl)
        fetchContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.dismiss()
    }
    
    deinit {
        
        print("HomeViewController deinited")
    }
    
    // MARK: Actions
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        firstly {
            APIManager.fetchMachines()
        }.then { object -> Void in
            DataManager.shared.save(object)
            NavigationManager.shared.presentSettingsViewController()
        }.catch { error in
            SVProgressHUD.dismiss()
            //Handle Error
        }
    }
    
    @IBAction func refreshTokenTest(_ sender: UIBarButtonItem) {
        
        AuthorizationManager.refreshRequest { error in
            //print(error)
        }
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchProducts()
        fetchAccount()
        fetchFavorites()
        refreshControl.endRefreshing()
    }
    
    override func updateProducts() {
        
        updateCollectionView()
    }
    
    override func updateAccount() {
        
        guard let balance = DataManager.shared.balance() else { return /* show */ }
        updateBalance(with: balance)
    }
    
    fileprivate func updateCollectionView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func updateBalance(with amount: Int) {
        
        DispatchQueue.main.async { [unowned self] in
            self.balanceLabel.text = "Your balance is \(amount) coins"
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories == nil ? 0 : categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        guard let categories = categories, let products = categories[indexPath.item].products else { return cell }
        if !products.isEmpty {
            return cell.configure(with: categories[indexPath.item])
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
