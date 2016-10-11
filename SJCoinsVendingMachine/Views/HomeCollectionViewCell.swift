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
    
    fileprivate var categoryNames: String? {
        didSet {
            if let name = categoryNames {
                categoryNameLabel.text = name
            }
        }
    }
    fileprivate var categoryItems: [Products]?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        categoryNameLabel.text = ""
        collectionView.scrollsToTop = true
    }
    
    @IBAction fileprivate func seeAllButtonPressed(_ sender: UIButton) {
        
        print("seeAllButtonPressed")
//        Reachability.ifConnectedToNetwork { [unowned self] in
//            guard let categoryNames = self.categoryNames else { return }
//            switch categoryNames {
//            case category.lastAdded:
//                NavigationMager.presentAllProductsViewController(with: self.categoryItems, mode: .lastAdded)
//            case category.bestSellers:
//                NavigationMager.presentAllProductsViewController(with: self.categoryItems, mode: .bestSellers)
//            case category.snacks:
//                NavigationMager.presentAllProductsViewController(with: self.categoryItems, mode: .snaks)
//            case category.drinks:
//                NavigationMager.presentAllProductsViewController(with: self.categoryItems, mode: .drinks)
//            default: break
//            }
//        }
    }
    
    func configure(with item: Categories) -> HomeCollectionViewCell {
        
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
        return categoryItems == nil ? cell : cell.configure(with: categoryItems![indexPath.item])
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let id = categoryItems?[indexPath.item].internalIdentifier
        let name = categoryItems?[indexPath.item].name
        let price = categoryItems?[indexPath.item].price
        
//        //Present confirmation message.
//        let navigation = NavigationMager.tabBarController?.selectedViewController as! UINavigationController //FIXME: fatal error: unexpectedly found nil while unwrapping an Optional value
//        let homeController = navigation.visibleViewController as! HomeViewController
//        homeController.presentConfirmation(with: id, name: name, price: price)
    }
}
