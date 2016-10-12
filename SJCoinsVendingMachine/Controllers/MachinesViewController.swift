//
//  MachinesViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 10/12/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class MachinesViewController: UITableViewController {
    
    // MARK: Constants
    static let identifier = "\(MachinesViewController.self)"
    let cellIdentifier = "MachinesTableViewCell"

    // MARK: Property
    fileprivate var machines: [MachinesModel]? {
        return DataManager.shared.machinesModel()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("sdf")
        //SVProgressHUD.dismiss()
    }
    
    deinit {
        print("MachinesViewController deinited")
    }
    
    // MARK: Actions
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        NavigationManager.shared.presentLoginViewController()
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return machines == nil ? 0 : machines!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let machines = machines else { return cell }
        if !machines.isEmpty {
            cell.textLabel?.text = machines[indexPath.item].name
        }
        return cell
    }
    
    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let id = machines?[indexPath.item].internalIdentifier else { return }
        AuthorizationManager.save(machineId: id)
        NavigationManager.shared.presentTabBarController()
    }
    
}
