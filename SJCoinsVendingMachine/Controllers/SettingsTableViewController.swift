//
//  SettingsTableViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/13/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: Constants
    let settingsCellIdentifier = "settingsCellIdentifier"
    
    // MARK: Property
    fileprivate var machines: [MachinesModel]? {
        
        return DataManager.shared.machines
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    deinit {
        
        print("SettingsTableViewController deinited")
    }
    
    // MARK: Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        NotificationCenter.default.post(name: .machineChanged, object: nil)
        downloadData()
    }
    
    private func downloadData() {
    
        firstly {
            APIManager.fetchProducts(machineID: AuthorizationManager.getMachineId())
        }.then { object -> Void in
            DataManager.shared.save(object)
        }.catch { error in
            SVProgressHUD.dismiss(withDelay: 0.5)
            AlertManager().present(alert: myError.title.download, message: error.localizedDescription)
        }.then {
            APIManager.fetchFavorites()
        }.then { object -> Void in
            DataManager.shared.save(object)
        }.catch { error in
            SVProgressHUD.dismiss(withDelay: 0.5)
            AlertManager().present(alert: myError.title.download, message: error.localizedDescription)
        }.then {
            APIManager.fetchAccount()
        }.then { object -> Void in
            DataManager.shared.save(object)
            SVProgressHUD.dismiss(withDelay: 2.0) { self.dismiss(animated: true) { } }
        }.catch { error in
            SVProgressHUD.dismiss(withDelay: 0.5)
            AlertManager().present(alert: myError.title.download, message: error.localizedDescription)
        }
    }
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Vending machines"
        default:
            return "Other settings"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return machines == nil ? 0 : machines!.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            guard let machine = machines else { return cell }
            let machineId = AuthorizationManager.getMachineId()
            cell.textLabel?.text = machine[indexPath.item].name
            if machine[indexPath.item].internalIdentifier == machineId {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        default:
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let machine = machines else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        AuthorizationManager.save(machineId: machine[indexPath.item].internalIdentifier!)
        tableView.reloadData()
    }
}
