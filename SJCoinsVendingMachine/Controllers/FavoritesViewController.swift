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
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var noItemsLabel: UILabel!
    
    fileprivate var favorites: [Products]? {
        return SortingHelper().sortBy(name: DataManager.shared.favorites, state: nil)
    }
    fileprivate var unavailable: [Int]? {
        return DataManager.shared.unavailable
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        noItemsLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
        connectionVerification { }
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        //PullToRefresh
        firstly {
            fetchFavorites().asVoid()
        }.then {
            self.tableView.reloadData()
        }.catch { _ in
            self.present(alert: .downloading)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favorites == nil || (favorites?.isEmpty)! {
            noItemsLabel.isHidden = false
            noItemsLabel.text = labels.noItems
            return 0
        } else {
            noItemsLabel.isHidden = true
            return favorites!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        guard let item = favorites?[indexPath.item] else { return cell }
        cell.delegate = self
        cell.availability = true
        if unavailable != nil && item.identifier != nil {
            if (unavailable?.contains(item.identifier!))! {
                cell.availability = false
            }
        }
        return cell.configure(with: item)
    }
}

extension FavoritesViewController: CellDelegate {
    
    // MARK: CellDelegate
    func remove(favorite cell: BaseTableViewCell) {
        
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        remove(favorite: cell.item) { [unowned self] in
            cell.favorite = false
            self.tableView?.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func buy(product item: Products) {
        
        present(confirmation: item)
    }
}
