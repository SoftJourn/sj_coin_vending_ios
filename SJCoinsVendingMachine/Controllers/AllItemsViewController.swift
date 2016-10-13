//
//  SJCAllItemsViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/11/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

enum Filter {
    case lastAdded
    case bestSellers
    case allItems
    case snaks
    case drinks
}

protocol FavoriteCellDelegate: class {
    
    func add(favorite identifier: Int, name: String)
    func remove(favorite identifier: Int, name: String)
}

class AllItemsViewController: BaseViewController {
    
    // MARK: Constants
    static let identifier = "\(AllItemsViewController.self)"
    
    // MARK: Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!
    @IBOutlet fileprivate weak var titleButton: UIButton!
    
    fileprivate lazy var searchData = [Products]()
    fileprivate lazy var sortingManager = SortingManager()
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
    //fileprivate var allProducts: ItemModel? {
        //return DataManager.shared.featuresModel()
    //}
    
    var filterMode: Filter = .allItems
    var filterItems: [Products]?
    var usedSeeAll = false
    var searchFinished = false
    
    // MARK: Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //NavigationMager.tabBarController?.delegate = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        filterItems = allItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NavigationManager.shared.visibleViewController = self
        //SVProgressHUD.dismiss()
        //changeFilter(to: filterMode, items: filterItems)
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
        
        dump(allItems)
        filterItems = allItems
        if filterItems != nil {
            self.configureAndReloadData(nil, array: self.filterItems)
        }
    }
    
    fileprivate func presentBuyingResult(with title: String, message: String) {
        
        let alertController = UIAlertController.presentAlert(with: title, message: message)
        present(alertController, animated: true) { }
    }
    
    // MARK: Filtering.
    fileprivate func predefinedActions() -> [UIAlertAction] {
        
        //Creating actions for ActionSheet and handle closures.
        let allItems = UIAlertAction(title: category.allItems, style: .default) { [unowned self] action in
            self.saveAndChange(filterMode: .allItems, items: self.allItems)
        }
        let lastAdded = UIAlertAction(title: category.lastAdded, style: .default) { [unowned self] action in
            //self.saveAndChange(filterMode: .lastAdded, items: self.allProducts?.newProducts)
        }
        let bestSellers = UIAlertAction(title: category.bestSellers, style: .default) { [unowned self] action in
            //self.saveAndChange(filterMode: .bestSellers, items: self.allProducts?.bestSellers)
        }
        let snacks = UIAlertAction(title: category.snacks, style: .default) { [unowned self] action in
            //self.saveAndChange(filterMode: .snaks, items: self.allProducts?.snack)
        }
        let drinks = UIAlertAction(title: category.drinks, style: .default) { [unowned self] action in
            //self.saveAndChange(filterMode: .drinks, items: self.allProducts?.drink)
        }
        let cancel = UIAlertAction(title: category.cancel, style: .cancel) { action in }

        return [allItems, lastAdded, bestSellers, snacks, drinks, cancel]
    }
    
    fileprivate func saveAndChange(filterMode mode: Filter, items: [Products]?) {
        
        let sortedItems = SortingManager().sortBy(name: items)
        filterItems = sortedItems
        filterMode = mode
        changeFilter(to: mode, items: sortedItems)
    }
    
    fileprivate func changeFilter(to mode: Filter, items: [Products]?) {
        
        switch mode {
        case .allItems:
            configureAndReloadData("\(category.allItems) ▾", array: items)
        case .lastAdded:
            configureAndReloadData("\(category.lastAdded) ▾", array: items)
        case .bestSellers:
            configureAndReloadData("\(category.bestSellers) ▾", array: items)
        case .snaks:
            configureAndReloadData("\(category.snacks) ▾", array: items)
        case .drinks:
            configureAndReloadData("\(category.drinks) ▾", array: items)
        }
    }
    
    fileprivate func configureAndReloadData(_ buttonTitle: String?, array: [Products]?) {
        
        setAndReload(data: array)
        guard let buttonTitle = buttonTitle else { return }
        titleButton.setTitle(buttonTitle, for: UIControlState())
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
            guard let items = filterItems else  { return cell }
            cell.delegate = self
            load(image: items[indexPath.item].imageUrl, forCell: cell)
            return cell.configure(with: items[indexPath.item])
        }
    }
    
    fileprivate func load(image endpoint: String?, forCell cell: AllItemsTableViewCell) {
        
        guard let endpoint = endpoint else { return }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            APIManager.fetch(image: endpoint) { image in
                cell.logo.image = image
            }
            return
        }
        cell.logo.image = cashedImage
    }
    
    // MARK: UITableViewDelegate
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
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

extension AllItemsViewController: UITabBarControllerDelegate {
    
    // MARK: UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        resultSearchController.dismiss(animated: true) { }
    }
}

extension AllItemsViewController: FavoriteCellDelegate {
    
    // MARK: FavoriteCellDelegate
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
}
