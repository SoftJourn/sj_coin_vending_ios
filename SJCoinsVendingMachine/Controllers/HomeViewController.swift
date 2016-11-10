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
    fileprivate let cellHeight: CGFloat = 180
    
    // MARK: Properties
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet private weak var balanceLabel: UILabel!
    
    fileprivate var categories: [Categories]? {
        return DataManager.shared.categories
    }
    fileprivate var unavailable: [Int]? {
        return DataManager.shared.unavailable
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.addSubview(refreshControl)
        addObserver(self, forKeyPath: #keyPath(dataManager.favorites), options: [.new], context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        navigationItem.title = DataManager.shared.machineName
        updateBalance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
        connectionVerification { }
    }
    
    deinit {
        
        removeObserver(self, forKeyPath: #keyPath(dataManager.favorites))
        print("HomeViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        NavigationManager.shared.presentSettingsViewController()
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        //PullToRefresh
        firstly {
            self.fetchProducts().asVoid()
        }.then {
            self.updateCollectionView()
        }.catch { error in
            print(error)
            self.present(alert: .downloading)
        }
    }
    
    fileprivate func updateCollectionView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
            SVProgressHUD.dismiss(withDelay: 0.2)
        }
    }
    
    private func updateBalance() {
        
        guard let balance = DataManager.shared.account?.amount else { return }
        DispatchQueue.main.async { [unowned self] in
            self.balanceLabel.text = "Your balance is \(balance) coins"
        }
    }
    
    override func updateUIafterBuying() {
        
        updateBalance()
    }
    
    // MARK: - Key-Value Observing
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else { return }
        switch keyPath {
        case #keyPath(dataManager.favorites):
            collectionView.reloadData()
        default: break
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
        //fatal error: Index out of range
        guard let categories = categories?[indexPath.item], let products = categories.products else { return cell }
        if !products.isEmpty {
            cell.delegate = self
            if categories.name == categoryName.favorites {
                return cell.configure(with: categories, unavailable: unavailable)
            } else {
                return cell.configure(with: categories, unavailable: nil)
            }
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
    func add(favorite cell: BaseTableViewCell) {
        
    }
    
    func remove(favorite cell: BaseTableViewCell) {
        
    }
    
    func buy(product item: Products) {
        
        present(confirmation: item)
    }
}
