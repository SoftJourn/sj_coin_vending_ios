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
    weak var delegate: CellDelegate?
    fileprivate var categoryItems: [Products]?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        categoryNameLabel.text = ""
        collectionView.scrollsToTop = true
    }
    
    @IBAction fileprivate func seeAllButtonPressed(_ sender: UIButton) {
        
        print(categoryNames)
        guard let items = categoryItems else { return }
        NavigationManager.shared.presentAllItemsViewController(name: categoryNames, items: items)
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
        
        guard let item = categoryItems?[indexPath.item] else { return cell }
        load(image: item.imageUrl, cell: cell)
        return cell.configure(with: item)
    }
    
    func load(image endpoint: String?, cell: HomeCollectionViewInternalCell) {
        
        guard let endpoint = endpoint else { return cell.logo.image = UIImage(named: "Placeholder")! }
        guard let cashedImage = DataManager.imageCache.image(withIdentifier: endpoint) else {
            APIManager.fetch(image: endpoint) { image in
                cell.logo.image = image
            }
            return
        }
        return cell.logo.image = cashedImage
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = categoryItems?[indexPath.item], let identifier = item.internalIdentifier, let name = item.name, let price = item.price else {
            
            //Present buying error Alert.
            return
        }
        delegate?.buy(product: identifier, name: name, price: price)
    }
}
