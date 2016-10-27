//
//  SettingsViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/13/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class SettingsViewController: BaseViewController {
    
    // MARK: Constants
    let settingsCellIdentifier = "settingsCellIdentifier"
    
    // MARK: Property
    fileprivate var machines: [MachinesModel]? {
        
        return DataManager.shared.machines
    }
    private var machineIdentifier: Int?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        machineIdentifier = AuthorizationManager.getMachineId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        super.viewDidAppear(true)
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    deinit {
        
        print("SettingsTableViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        let newMachineIdentifier = AuthorizationManager.getMachineId()
        if newMachineIdentifier == machineIdentifier {
            self.dismiss(animated: true) { }
        } else {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            firstly {
                self.fetchProducts().asVoid()
            }.then {
                self.updateProducts()
            }
        }
    }
    
    func updateProducts() {
        
        SVProgressHUD.dismiss(withDelay: 2.0) {
            self.dismiss(animated: true) { }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Vending machines"
        default:
            return "Other settings"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return machines == nil ? 0 : machines!.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let machine = machines?[indexPath.item] else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if let identifier = machine.internalIdentifier {
            AuthorizationManager.save(machineId: identifier)
        }
        tableView.reloadData()
    }
}
