//
//  InformativePageViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 12/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class InformativePageViewController: UIPageViewController {

    // MARK: Properties
    var firstTime = false
    fileprivate lazy var pageViewControllers: [UIViewController] = {
        return NavigationManager.shared.pageViewControllers
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        launching()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                let view = view as! UIPageControl
                view.backgroundColor = .clear
                view.pageIndicatorTintColor = .darkGray
                view.currentPageIndicatorTintColor = .black
            }
        }
    }
    
    deinit {
        
        print("InformativePageViewController DELETED.")
    }
    
    // MARK: Methods
    func launching() {
        
        guard let info = pageViewControllers.first, let login = pageViewControllers.last else { return }
        firstTime ? show(controller: info) : show(controller: login)
    }
    
    private func show(controller: UIViewController) {
        
        return setViewControllers([controller], direction: .forward, animated: true) { _ in }
    }
}

extension InformativePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllers.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pageViewControllers.count > previousIndex else { return nil }
        return pageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pageViewControllers.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard pageViewControllers.count > nextIndex else { return nil }
        return pageViewControllers[nextIndex]
    }
    
    // The number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return pageViewControllers.count
    }
    
    // The selected item reflected in the page indicator.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = viewControllers?.first else { return 0 }
        return pageViewControllers.index(of: firstViewController) ?? 0
    }
}
