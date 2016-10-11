//
//  FavoritesViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 9/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

class FavoritesViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    //fileprivate var refreshControl = UIRefreshControl()
    fileprivate var favoritesProducts: [Products]? {
        return DataManager.shared.favorite()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        //pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        SVProgressHUD.dismiss()
    }
    
    // MARK: Configuration.
//    fileprivate func pullToRefresh() {
//        
//        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
//        refreshControl.addTarget(self, action: #selector(fetchContent), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
//    }
    
    // MARK: Downloading, Handling and Refreshing data.
    func fetchContent() {
        
        fetchFavorites()
        //refreshControl.endRefreshing()
    }
    
    override func updateFavorites() {
        
        reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoritesProducts == nil ? 0 : favoritesProducts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
        return cell
        //return favoritesProducts == nil ? cell : cell.configure(with: favoritesProducts![indexPath.item])
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
