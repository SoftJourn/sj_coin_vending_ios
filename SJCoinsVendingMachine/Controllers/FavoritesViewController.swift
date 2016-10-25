//
//  FavoritesViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class FavoritesViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var favorites: [Products]? {
        
        return SortingManager().sortBy(name: DataManager.shared.favorites)
    }
    
    fileprivate var notAvailable: [Int]? {
        
        return DataManager.shared.notAvailable
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
        if !Reachability.connectedToNetwork() {
            present(alert: .connection)
        }
    }
    
    deinit {
        
        print("FavoritesViewController deinited")
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchFavorites()
    }
    
    override func updateFavorites() {
        
        reloadTableView()
    }
    
    private func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            //SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites == nil ? 0 : favorites!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        guard let item = favorites?[indexPath.item] else { return cell }
        cell.delegate = self
        cell.availability = true
        if notAvailable != nil && item.internalIdentifier != nil {
            if (notAvailable?.contains(item.internalIdentifier!))! {
                cell.availability = false
            }
        }
        
        return cell.configure(with: item)
    }
    
    
    // MARK: UITableViewDelegate

}

extension FavoritesViewController: CellDelegate {
    
    func add(favorite cell: BaseTableViewCell) {
        
        //From Favorite tab user can only delete product.
    }
    
    func remove(favorite cell: BaseTableViewCell) {
        
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        remove(favorite: cell.item) { [unowned self] in
            self.tableView?.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func buy(product item: Products) {
        
        present(confirmation: item)
    }
}
