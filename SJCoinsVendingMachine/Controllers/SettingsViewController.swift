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
    fileprivate let settingsCellIdentifier = "settingsCellIdentifier"
    
    // MARK: Property
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var machines: [MachinesModel]? {
        return DataManager.shared.machines
    }
    fileprivate var oldMachineId: Int!
    fileprivate var chosenMachineID = DataManager.shared.machineId
    fileprivate var chosenMachineName = DataManager.shared.machineName
    fileprivate var headerView: UIView {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 30, y: 16, width: 300, height: 20))
        label.textAlignment = .left
        Reachability.connectedToNetwork() ? success(label) : failed(label)
        view.addSubview(label)
        return view
    }

    weak var delegate: SettingsViewControllerDelegate?

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
            //Fetch content to chosen vending machine
            newContent()
        }
    }
    
    // MARK: Methods
    override func fetchData() {
        
        if Reachability.connectedToNetwork() {
            //Fetch and display machines list.
            fetchContent()
        } else {
            //Change table header and show alert.
            reloadTableView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [unowned self] in
                self.present(alert: .connection)
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func fetchContent() {
        
        SVProgressHUD.show(withStatus: spinerMessage.loading)
        firstly {
            fetchMachinesList().asVoid()
        }.then {
            self.reloadTableView()
        }.catch { _ in
            SVProgressHUD.dismiss()
            let actions = AlertManager().alertActions(cancel: true) { [unowned self] in
                self.fetchContent()
            }
            self.present(alert: .retryLaunch(actions))
        }
    }

    private func reloadTableView() {
        
        SVProgressHUD.dismiss()
        tableView.reloadData()
    }
    
    private func newContent() {
        
        let favorites = fetchFavorites()
        let products = fetchProducts()
        let account = fetchAccount()
        
        when(fulfilled: favorites, products, account).then { [unowned self] _ -> Void in
            SVProgressHUD.dismiss()
            //Reload table view in home controller.
            self.delegate?.machineDidChange()
            self.dismiss(animated: true) { }
        }.catch { _ in
            SVProgressHUD.dismiss()
            let actions = AlertManager().alertActions(cancel: true) {
                self.fetchContent() //FIXME: Verify
            }
            self.present(alert: .retryLaunch(actions))
        }
    }
    
    // MARK: Label decorations.
    private func success(_ label: UILabel) {
        
        label.text = "Vending machines"
        label.textColor = UIColor.gray
    }
    
    private func failed(_ label: UILabel) {
        
        label.text = "No Internet connection"
        label.textColor = UIColor.red
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
            return headerView
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
