////
////  MachinesViewController.swift
////  SJCoinsVendingMachine
////
////  Created by Oleg Pankiv on 10/12/16.
////  Copyright © 2016 Softjourn. All rights reserved.
////
//
//import UIKit
//import SVProgressHUD
//import PromiseKit
//
//class MachinesViewController: BaseViewController {
//    
//    // MARK: Constants
//    static let identifier = "\(MachinesViewController.self)"
//    let cellIdentifier = "MachinesTableViewCell"
//
//   fileprivate var machines: [MachinesModel]? {
//        return DataManager.shared.machinesModel()
//    }//
//    // MARK: Life cycle
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        tableView.addSubview(refreshControl)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        
//        navigationController?.isNavigationBarHidden = false
//        NavigationManager.shared.visibleViewController = self
//        SVProgressHUD.dismiss()
//    }
//    
//    deinit {
//        
//        print("MachinesViewController deinited")
//    }
//    
//    override func fetchContent() {
//        
//        firstly {
//            APIManager.fetchMachines()
//        }.then { object -> Void in
//            DataManager.shared.save(object)
//            self.reloadTableView()
//        }.catch { error in
//            SVProgressHUD.dismiss()
//            AlertManager().present(retryAlert: errorTitle.download, message: errorMessage.retryDownload, actions: self.predefinedAction())
//        }
//        refreshControl.endRefreshing()
//    }
//
//    fileprivate func predefinedAction() -> [UIAlertAction] {
//        
//        //Creating actions for ActionSheet and handle closures.
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in }
//        let retry = UIAlertAction(title: "Retry", style: .destructive) { [unowned self] action in
//            SVProgressHUD.show()
//            self.fetchContent()
//        }
//        return [cancel, retry]
//    }
//
//    func reloadTableView() {
//        
//        DispatchQueue.main.async { [unowned self] in
//            self.tableView.reloadData()
//        }
//    }
//}
//
//extension MachinesViewController: UITableViewDataSource, UITableViewDelegate {
//
//    // MARK: UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        //dump(machines)
//        return machines == nil ? 0 : machines!.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//        guard let machines = machines else { return cell }
//        if !machines.isEmpty {
//            cell.textLabel?.text = machines[indexPath.item].name
//        }
//        return cell
//    }
//    
//    // MARK: UITableViewDelegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        guard let id = machines?[indexPath.item].internalIdentifier else { return }
//        AuthorizationManager.save(machineId: id)
//        dismiss(animated: true) { }
//        //reload data in controllers.
//    }
//}
