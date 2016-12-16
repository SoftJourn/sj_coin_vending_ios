//
//  ProductsTableViewCell.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 8/10/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Constants
    static let identifier = "\(HomeCollectionViewCell.self)"
    
    // MARK: Properties
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var showAllButton: UIButton!
    
    fileprivate var categoryNames: String? {
        didSet {
            if let name = categoryNames {
                categoryNameLabel.text = name
            }
        }
    }
    fileprivate var categoryItems: [Products]?
    weak var delegate: CellDelegate?
    fileprivate var unavailableFavorites: [Int]?
    fileprivate var availability: Bool = true

    override func prepareForReuse() {
        
        super.prepareForReuse()
        categoryItems = nil
        categoryNameLabel.text = ""
        collectionView.scrollsToTop = true
        showAllButton.isHidden = false
        //collectionView.reloadData()
    }
    
    @IBAction private func seeAllButtonPressed(_ sender: UIButton) {
        
        guard let items = categoryItems else { return }
        categoryNames == categoryName.favorites
            ? NavigationManager.shared.presentFavoritesViewController(items: items)
            : NavigationManager.shared.presentAllItemsViewController(name: categoryNames, items: items)
    }
    
    func configure(with item: Categories, unavailable: [Int]?) {
       
        if unavailable != nil {
            unavailableFavorites = unavailable
        }
        categoryNames = item.name
        categoryItems = item.products
        collectionView.reloadData()
    }
}

extension HomeCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryItems == nil ? 0 : categoryItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewInternalCell.identifier, for: indexPath)
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? HomeCollectionViewInternalCell, let item = categoryItems?[indexPath.item] else { return }
        cell.availability = true
        cell.configure(with: item)
        checkFavorite(item) { cell.availability = false }
    }
    
    private func checkFavorite(_ item: Products, with action: ()->()) {
        
        if categoryNames == categoryName.favorites {
            guard let unavailable = unavailableFavorites, let identifier = item.identifier else { return }
            if unavailable.contains(identifier) {
                action()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = categoryItems?[indexPath.item] else { return }
        checkFavorite(item) { availability = false }
        
        if Helper.connectedToNetwork() {
            availability ? delegate?.buy(product: item) : presenError()
            availability = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + time.halfSecond) {
                AlertManager().present(alert: errorMessage.reachability)
            }
        }
    }
    
    private func presenError() {
        
        AlertManager().present(alert: errorMessage.available)
    }
}
