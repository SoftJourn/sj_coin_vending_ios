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

/*
 FIXME: Application runned at first time.
 FechProduct called before default Vending Machnine ID saved in UserDefaults.
 Thats why first api call return 404 error.
 */

class HomeViewController: BaseViewController {
    
    // MARK: Constants
    let cellHeight: CGFloat = 180
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    fileprivate var categories: [Categories]? {

        return DataManager.shared.categories
    }
    fileprivate var unavailable: [Int]? {
        
        return DataManager.shared.unavailable
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchMachinesFirstTime()
        collectionView.addSubview(refreshControl)
        fetchContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //updateCollectionView()
        updateBalance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
        connectionVerification { }
    }
    
    deinit {
        
        print("HomeViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
        connectionVerification {
            fetchMachines { _ in
                NavigationManager.shared.presentSettingsViewController()
            }
        }
    }
    
    // MARK: Set default vending machnine when app launched first time.
    private func fetchMachinesFirstTime() {
        
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
    
    private func fetchMachines(complition: @escaping (_ object: AnyObject)->()) {
        
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        firstly {
            APIManager.fetchMachines()
        }.then { object -> Void in
            DataManager.shared.save(object)
            complition(object)
        }.catch { error in
            SVProgressHUD.dismiss(withDelay: 0.5)
            //AlertManager().present(retryAlert: errorTitle.download, message: errorMessage.retryDownload, actions: self.retryActions())
        }
    }
    
    private func retryActions() -> [UIAlertAction] {
        
        let confirmButton = UIAlertAction(title: buttonTitle.retry , style: .destructive) { [unowned self] action in
            self.fetchMachines { _ in
                SVProgressHUD.dismiss(withDelay: 0.5)
            }
        }
        let cancelButton = UIAlertAction(title: buttonTitle.cancel, style: .default, handler: nil)
        return [cancelButton, confirmButton]
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        firstly {
            self.fetchProducts().asVoid()
        }.then {
            self.updateCollectionView()
        }
    }
    
    fileprivate func updateCollectionView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
    
    private func updateBalance() {
        
        guard let balance = DataManager.shared.account?.amount else { return /* show */ }
        
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
