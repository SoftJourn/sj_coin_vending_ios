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
import PromiseKit

class AccountViewController: BaseViewController {
    
    // MARK: Constants
    
    // MARK: Properties
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var amountLabel: UILabel!
    @IBOutlet fileprivate var tableView: UITableView!
    
    fileprivate var accountInformation: AccountModel? {
        
        return DataManager.shared.account
    }
    fileprivate var purchases: [PurchaseHistoryModel]? {
        
        return DataManager.shared.purchases
    }
    
    // MARK: Life cycle
    override internal func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        fetchContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
        if !Reachability.connectedToNetwork() {
            present(alert: .connection)
        }
    }
    
    deinit {
        
        print("AccountViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func logOutButton(_ sender: UIBarButtonItem) {
        
        //ExecuteLogOut
        AuthorizationManager.removeAccessToken()
        NavigationManager.shared.presentLoginViewController()
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        firstly {
            fetchPurchaseHistory().asVoid()
        }.then {
            self.updateTableView()
        }.then {
            self.fetchAccount().asVoid()
        }.then {
            self.updateViewWithAccountContent()
        }
    }
    
    private func updateTableView() {
        
        SVProgressHUD.dismiss(withDelay: 1)
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    private func updateViewWithAccountContent() {
        
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
        
        guard let item = purchases?[indexPath.item], let price = item.price, let name = item.name else  { return cell }
        let date = DateManager().convertData(from: item.time!)
        cell.transactionDate.text = date
        cell.transactionItem.text = name
        cell.transactionPrice.text = "\(price) Coins"
        return cell        
    }
    
    // MARK: UITableViewDelegate
}
