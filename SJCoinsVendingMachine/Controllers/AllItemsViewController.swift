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
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var titleButton: UIButton!
    
    private var sortingManager = SortingManager()
    fileprivate lazy var searchData = [Products]()
    fileprivate lazy var resultSearchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    private var allItems: [Products]? {
        
        return DataManager.shared.allItems
    }
    private var lastAdded: [Products]? {
        
        return DataManager.shared.lastAdded
    }
    private var bestSellers: [Products]? {
        
        return DataManager.shared.bestSellers
    }
    private var categories: [Categories]? {
        
        return DataManager.shared.features?.categories
    }
    fileprivate var favorite: [Products]? {
        
        return DataManager.shared.favorites
    }
    
    var filterItems: [Products]?
    var usedSeeAll = false
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        usedSeeAll ? viewDidLoadUsingSeeAll() : viewDidLoadNotUsingSeeAll()
    }
    
    private func viewDidLoadUsingSeeAll() {
        
        titleButton.removeTarget(self, action: #selector(self.titleButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func viewDidLoadNotUsingSeeAll() {
        
        filterItems = SortingManager().sortBy(name: allItems)
        tableView.addSubview(refreshControl)
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        NavigationManager.shared.visibleViewController = self
    }
    
    deinit {
        
        print("AllItemsViewController deinited")
    }
    
    // MARK: Actions
    @IBAction private func sameSegmentButtonPressed(_ sender: UISegmentedControl) {
        
        sortItems()
    }
    
    @IBAction private func anothedSegmentButtonPressed(_ sender: UISegmentedControl) {
       
        sortItems()
    }
    
    @IBAction private func searchButtonPressed(_ sender: UIBarButtonItem) {
        
        present(resultSearchController, animated: true) { }
    }
    
    @IBAction private func titleButtonPressed(_ sender: UIButton) {
        
        //Present ActionSheet.
        AlertManager().present(actionSheet: predefinedActions())
    }
    
    // MARK: Downloading, Handling and Refreshing data.
    override func fetchContent() {
        
        fetchProducts()
    }
    
    override func updateProducts() {
        
        if filterItems != nil {
            self.change(filter: self.prepared(name: categoryName.allItems), items: self.allItems)
        }
        reloadTableView()
    }

    // MARK: Sorting via Segment Control.
    private func sortItems() {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            setAndReload(data: sortingManager.sortBy(name: filterItems))
        case 1:
            setAndReload(data: sortingManager.sortBy(price: filterItems))
        default: break
        }
    }
    
    // MARK: Filtering via BarButton and ActionSheet.
    fileprivate func predefinedActions() -> [UIAlertAction] {
        
        var actions = [UIAlertAction]()
        //Creating actions for ActionSheet and handle closures.
        let allItems = UIAlertAction(title: categoryName.allItems, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: categoryName.allItems), items: self.allItems)
        }
        actions.append(allItems)
        
        let lastAdded = UIAlertAction(title: categoryName.lastAdded, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: categoryName.lastAdded), items: self.lastAdded)
        }
        actions.append(lastAdded)
        
        let bestSellers = UIAlertAction(title: categoryName.bestSellers, style: .default) { [unowned self] action in
            self.change(filter: self.prepared(name: categoryName.bestSellers), items: self.bestSellers)
        }
        actions.append(bestSellers)
        
        let cancel = UIAlertAction(title: categoryName.cancel, style: .cancel) { action in }
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
    
    private func prepared(name: String) -> String {
        
        return "\(name) ▾"
    }
    
    //MARK: Others
    private func setAndReload(data array: [Products]?) {
        
        filterItems = array
        reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            SVProgressHUD.dismiss(withDelay: 0.5)
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
            guard let item = filterItems?[indexPath.row] else { return cell }
            cell.delegate = self
            cell.favorite = false
            if let favorites = favorite {
                for object in favorites {
                    if item == object {
                        cell.favorite = true
                    }
                }
            }
            
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
    func add(favorite cell: BaseTableViewCell) {
        
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        add(favorite: cell.item) { [unowned self] in
            self.tableView?.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func remove(favorite cell: BaseTableViewCell) {
        
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        remove(favorite: cell.item) { [unowned self] in
            self.tableView?.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func buy(product item: Products) {
        
        present(confirmation: item)
    }
}
