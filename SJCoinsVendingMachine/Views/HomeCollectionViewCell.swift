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
    @IBOutlet weak var showAllButton: UIButton!
    
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
        categoryNameLabel.text = ""
        collectionView.scrollsToTop = true
        showAllButton.isHidden = false
    }
    
    @IBAction private func seeAllButtonPressed(_ sender: UIButton) {
        
        guard let items = categoryItems else { return }
        if categoryNames == categoryName.favorites {
            NavigationManager.shared.presentFavoritesViewController(items: items)
        } else {
            NavigationManager.shared.presentAllItemsViewController(name: categoryNames, items: items)
        }
    }
    
    func configure(with item: Categories, unavailable: [Int]?) -> HomeCollectionViewCell {
       
        if unavailable != nil {
            unavailableFavorites = unavailable
        }
        categoryNames = item.name
        categoryItems = item.products
        reloadDataInside()
        return self
    }

    fileprivate func reloadDataInside() {
        
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
        }
    }
}

extension HomeCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryItems == nil ? 0 : categoryItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewInternalCell.identifier, for: indexPath) as! HomeCollectionViewInternalCell
        
        guard let item = categoryItems?[indexPath.item] else { return cell }
        cell.availability = true
        if categoryNames == categoryName.favorites {
            guard let unavailable = unavailableFavorites, let identifier = item.internalIdentifier else {
                return cell.configure(with: item)
            }
            if unavailable.contains(identifier) {
                cell.availability = false
            }
        }
        return cell.configure(with: item)
    }
        
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = categoryItems?[indexPath.item] else { return }
        if categoryNames == categoryName.favorites {
            guard let unavailable = unavailableFavorites, let identifier = item.internalIdentifier else { return }
            if unavailable.contains(identifier) {
                availability = false
            }
        }
        availability ? delegate?.buy(product: item) : presenError()
        availability = true
    }
    
    private func presenError() {
        
        AlertManager().present(alert: myError.title.available, message: myError.message.available)
    }
}
