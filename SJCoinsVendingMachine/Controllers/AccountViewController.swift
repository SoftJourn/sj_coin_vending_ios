//
//  SJCAccountViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD

class AccountViewController: BaseViewController {
    
    // MARK: Constants
    
    // MARK: Properties
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var amountLabel: UILabel!
    @IBOutlet fileprivate var tableView: UITableView!
    
    fileprivate var accountInformation: AccountModel? {
        return DataManager.shared.accountModel()
    }
    fileprivate var purchases: [Products]? {
        return nil
    }
    
    // MARK: Life cycle
    override internal func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        //SVProgressHUD.dismiss()
        fetchAccount()
    }
    
    deinit {
        
        print("AccountViewController deinited")
    }
    
    // MARK: Actions
    @IBAction fileprivate func logOutButton(_ sender: UIBarButtonItem) {
        
        //ExecuteLogOut
        //SVProgressHUD.show(withStatus: sign.outMessage)
        AuthorizationManager.removeAccessToken()
        NavigationManager.shared.presentLoginViewController()
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchProducts()
        fetchAccount()
        refreshControl.endRefreshing()
    }
    
    override func updateProducts() {
        
        updateTableView()
    }
    
    override func fetchAccount() {
        
        updateViewWithAccountContent()
    }
    fileprivate func updateTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    fileprivate func updateViewWithAccountContent() {
        
        guard let amount = accountInformation?.amount else { return }
        amountLabel.text = "\(String(amount)) Coins"
        guard let name = accountInformation?.name, let surname = accountInformation?.surname else { return }
        nameLabel.text = "\(name) \(surname)"
    }
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let names = purchases?.count else { return 0 }
        return names
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseHistoryTableViewCell.identifier, for: indexPath) as! PurchaseHistoryTableViewCell
        
        //guard let item = purchases?[indexPath.item] else  { return cell }
        //return cell.configure(with: item)

        
        //guard purchases != nil else { return cell }
//        let date = items[indexPath.row].productDate()
//        cell.transactionDate.text = DateManager().convertData(from: date)
//        cell.transactionItem.text = items[(indexPath as NSIndexPath).row].productName()
//        cell.transactionPrice.text = "\(items[(indexPath as NSIndexPath).row].productPrice()!) Coins"
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
