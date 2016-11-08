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
import SwiftyUserDefaults

class SettingsViewController: BaseViewController {
    
    // MARK: Constants
    let settingsCellIdentifier = "settingsCellIdentifier"
    
    // MARK: Property
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var machines: [MachinesModel]? {
        
        return DataManager.shared.machines
    }
    fileprivate var oldMachineId: Int!
    fileprivate var chosenMachineID = DataManager.shared.machineId
    fileprivate var chosenMachineName = DataManager.shared.machineName
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        oldMachineId = DataManager.shared.machineId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
    }
    
    deinit {
        
        print("SettingsTableViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        
        if DataManager.shared.machineId == chosenMachineID {
            self.dismiss(animated: true) { }
        } else {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
            DataManager.shared.machineId = self.chosenMachineID
            DataManager.shared.machineName = self.chosenMachineName
            
            firstly {
                self.fetchFavorites().asVoid()
            }.then {
                self.fetchProducts().asVoid()
            }.then {
                self.fetchAccount().asVoid()
            }.then {
                SVProgressHUD.dismiss()
            }.then {
                self.dismiss(animated: true) { }
            }.catch { error in
                print(error)
            }
        }
    }
    
    // MARK: Methods
    override func fetchData() {
        
        if Reachability.connectedToNetwork() {
            fetchContent()
        } else {
            reloadTableView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [unowned self] in
                self.present(alert: .connection)
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func fetchContent() {
        
        firstly {
            self.fetchMachinesList().asVoid()
        }.then {
            self.reloadTableView()
        }.catch { error in
            print(error)
        }
    }

    private func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let customView = UIView()
            let label = UILabel(frame: CGRect(x: 30, y: 16, width: 300, height: 20))
            label.textAlignment = .left

            if Reachability.connectedToNetwork() {
                label.text = "Vending machines"
                label.textColor = UIColor.gray
            } else {
                label.text = "No Internet connection"
                label.textColor = UIColor.red
            }
            customView.addSubview(label)
            return customView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return machines == nil ? 0 : machines!.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            guard let machine = machines else { return cell }
            cell.textLabel?.text = machine[indexPath.item].name
            if machine[indexPath.item].internalIdentifier == chosenMachineID {
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let machine = machines?[indexPath.item], let identifier = machine.internalIdentifier, let name = machine.name else { return }
        chosenMachineID = identifier
        chosenMachineName = name
        tableView.reloadData()
    }
}
