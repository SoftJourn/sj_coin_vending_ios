//
//  SJCAllItemsViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireImage

enum Filter {
    case lastAdded
    case bestSellers
    case allItems
}

class AllItemsViewController: BaseViewController {
    
    // MARK: Constants
    static let identifier = "\(AllItemsViewController.self)"
    
    // MARK: Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!
    @IBOutlet fileprivate weak var titleButton: UIButton!

    fileprivate var sortingManager = SortingManager()
    fileprivate lazy var searchData = [Products]()
    fileprivate lazy var resultSearchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    fileprivate var allItems: [Products]? {
        return DataManager.shared.allItems()
    }
    fileprivate var lastAdded: [Products]? {
        return DataManager.shared.lastAdded()
    }
    fileprivate var bestSellers: [Products]? {
        return DataManager.shared.bestSellers()
    }
    fileprivate var categories: [Categories]? {
        return DataManager.shared.category()
    }
    
    var filterMode: Filter = .allItems
    var filterItems: [Products]?
    var usedSeeAll = false
    var searchFinished = false
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        usedSeeAll ? viewDidLoadUsingSeeAll() : viewDidLoadNotUsingSeeAll()
        }
    
    func viewDidLoadUsingSeeAll() {
        
        titleButton.removeTarget(self, action: #selector(self.titleButtonPressed(_:)), for: .touchUpInside)
    }
    
    func viewDidLoadNotUsingSeeAll() {
        
        filterItems = allItems
        tableView.addSubview(refreshControl)
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        //SVProgressHUD.dismiss()
        filterItems = sortingManager.sortBy(name: filterItems)
    }
    
    deinit {
        
        print("AllItemsViewController deinited")
    }
    
    // MARK: Actions
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            let sortedByName = sortingManager.sortBy(name: filterItems)
            setAndReload(data: sortedByName)
        }
        
        if segmentControl.selectedSegmentIndex == 1 {
            let sortedByPrice = sortingManager.sortBy(price: filterItems)
            setAndReload(data: sortedByPrice)
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        present(resultSearchController, animated: true) { }
    }
    
    @IBAction func titleButtonPressed(_ sender: UIButton) {
        
        //Present ActionSheet.
        AlertManager().present(actionSheet: predefinedActions())
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchProducts()
        refreshControl.endRefreshing()
    }
    
    override func updateProducts() {
        
        filterItems = allItems
        if filterItems != nil {
            self.change(filter: nil, items: self.filterItems)
        }
    }
    
    // MARK: Filtering.
    fileprivate func predefinedActions() -> [UIAlertAction] {
        
        var actions = [UIAlertAction]()
        //Creating actions for ActionSheet and handle closures.
        let allItems = UIAlertAction(title: category.allItems, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: category.allItems), items: self.allItems)
        }
        actions.append(allItems)
        
        let lastAdded = UIAlertAction(title: category.lastAdded, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: category.lastAdded), items: self.lastAdded)
        }
        actions.append(lastAdded)

        let bestSellers = UIAlertAction(title: category.bestSellers, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: category.bestSellers), items: self.bestSellers)
        }
        actions.append(bestSellers)

        let cancel = UIAlertAction(title: category.cancel, style: .cancel) { action in }
        actions.append(cancel)
        
        guard let categories = categories else { return actions }
        for category in categories {
            guard let name = category.name, let items = category.products else { return actions }
            let action = UIAlertAction(title: name , style: .default) { [unowned self] action in
                self.change(filter: self.prepared(name: name), items: items)
            }
            actions.append(action)
        }
        return actions
    }
    
    fileprivate func change(filter name: String?, items: [Products]?) {
        
        
        let sortedItems = SortingManager().sortBy(name: items)
        filterItems = sortedItems
        titleButton(name)
        reloadTableView()
    }
    
    func titleButton(_ name: String?) {
        if name != nil {
            titleButton.setTitle(name, for: UIControlState())
        }
    }
    
    fileprivate func prepared(name: String) -> String {
        
        return "\(name) ▾"
    }
    
    //MARK: Others
    fileprivate func setAndReload(data array: [Products]?) {
        
        filterItems = array
        reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension AllItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.isActive {
            return searchData.count
        } else {
            return filterItems == nil ? 0 : filterItems!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AllItemsTableViewCell.identifier, for: indexPath) as! AllItemsTableViewCell
        if self.resultSearchController.isActive {
            return searchData.isEmpty ? cell : cell.configure(with: searchData[indexPath.item])
        } else {
            guard let item = filterItems?[indexPath.item] else { return cell }
            cell.delegate = self
            return cell.configure(with: item)
        }
    }
    
    // MARK: UITableViewDelegate

}

extension AllItemsViewController: UISearchResultsUpdating {
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filterItems = filterItems else { return }
        
        searchData.removeAll(keepingCapacity: false)
        
        let filterText = searchController.searchBar.text!
        if filterText.characters.count > 0 {
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", filterText)
            searchData = filterItems.filter { searchPredicate.evaluate(with: $0.name) }
        } else {
            searchData = filterItems
        }
        reloadTableView()
    }
}

extension AllItemsViewController: CellDelegate {
    
    // MARK: CellDelegate
    func add(favorite identifier: Int, name: String) {
        
        APIManager.favorite(.post, identifier: identifier) { [unowned self] object, error in
            if object != nil {
                //DataManager.shared.favorite(name)
                self.reloadTableView()
            }
        }
    }
    
    func remove(favorite identifier: Int, name: String) {
        
        APIManager.favorite(.delete, identifier: identifier) { [unowned self] object, error in
            if object != nil {
                //DataManager.shared.unfavorite(name)
                self.reloadTableView()
            }
        }
    }
    
    func buy(product identifier: Int, name: String, price: Int) {
        
        confirmation(identifier, name: name, price: price)
    }
}
