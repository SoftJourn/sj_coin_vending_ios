//
//  SJCAccountViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class AccountViewController: BaseViewController {
    
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
    
    // MARK: Lifecycle
    override internal func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        connectionVerification {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            fetchContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
    }
    
    // MARK: Actions
    @IBAction func qrCodeButtonPressed(_ sender: UIBarButtonItem) {
        
        AlertManager().present(actionSheet: qrCodeActions(), sender: sender)
    }
    
    @IBAction private func logOutButton(_ sender: UIBarButtonItem) {
        
        //ExecuteLogOut
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        firstly {
            AuthorizationManager.revokeRequest().asVoid()
        }.then {
            self.logOut()
        }.catch { _ in
            self.logOut()
        }
    }
    
    private func logOut() {
        
        //Clean accessToken locally
        AuthorizationManager.removeAccessToken()
        
        //Clean data locally
        DataManager.shared.cleanAllData()

        SVProgressHUD.dismiss()
        NavigationManager.shared.presentInformativePageViewController(firstTime: false)
    }
    
    fileprivate func qrCodeActions() -> [UIAlertAction] {
        
        //Creating actions for ActionSheet and handle closures.
        let qrGenerator = UIAlertAction(title: "Generator", style: .default) { action in
            NavigationManager.shared.presentQRGeneratorViewController()
        }
        let qrReader = UIAlertAction(title: "Reader", style: .default) { action in
        
        }
        let cancel = UIAlertAction(title: categoryName.cancel, style: .cancel) { action in }

        return [qrGenerator, qrReader, cancel]
    }

    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        //PullToRefresh
        firstly {
            fetchPurchaseHistory().asVoid()
        }.then {
            self.updateTableView()
        }.then {
            self.fetchAccount().asVoid()
        }.then {
            self.updateViewWithAccountContent()
        }.catch { _ in
            SVProgressHUD.dismiss()
            self.present(alert: .downloading)
        }
    }
    
    private func updateTableView() {
        
        SVProgressHUD.dismiss(withDelay: 0.2)
        tableView.reloadData()
    }
    
    private func updateViewWithAccountContent() {
        
        guard let amount = accountInformation?.amount else { return }
        amountLabel.text = "\(String(amount)) Coins"
        guard let name = accountInformation?.name, let surname = accountInformation?.surname else { return }
        nameLabel.text = "\(name) \(surname)"
    }
}

extension AccountViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let names = purchases?.count else { return 0 }
        return names
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseHistoryTableViewCell.identifier, for: indexPath) as! PurchaseHistoryTableViewCell
        
        guard let item = purchases?[indexPath.item], let price = item.price, let name = item.name, let time = item.time else { return cell }
        let date = Helper.convertDate(string: time)
        cell.transactionDate.text = date
        cell.transactionItem.text = name
        cell.transactionPrice.text = "\(price) Coins"
        return cell        
    }
}
