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
    
    fileprivate var unsortedFavorites: [Products]? {
        
        return DataManager.shared.favorite()
    }
    fileprivate var favorites: [Products]?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favorites = SortingManager().sortBy(name: unsortedFavorites)
        fetchContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        if !Reachability.connectedToNetwork() {
            AlertManager().presentInternetConnectionError { }
        } else {
            SVProgressHUD.show(withStatus: spinerMessage.loading)
        }
    }
    
    deinit {
        
        print("FavoritesViewController deinited")
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchFavorites {
            SVProgressHUD.dismiss()
        }
    }
    
    override func updateFavorites() {
        
        reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
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
        guard let item = favorites?[indexPath.item] else  { return cell }
        cell.delegate = self
        return cell.configure(with: item, index: indexPath)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: CellDelegate {
    
    func add(favorite item: Products, index: IndexPath) {
        guard let identifier = item.internalIdentifier else { return }
        APIManager.favorite(.post, identifier: identifier) { [unowned self] object, error in
            if error == nil {
                
                //reload cell
                self.reloadTableView()
            }
        }
        
    }
    
    func remove(favorite item: Products) {
        
//        APIManager.favorite(.delete, identifier: identifier) { [unowned self] object, error in
//            self.fetchFavorites {
//                //self.reloadTableView()
//            }
//        }
    }
    
    func buy(product identifier: Int, name: String, price: Int) {
        
        confirmation(identifier, name: name, price: price)
    }
}
