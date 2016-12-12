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
    var pageControl: UIPageControl?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        pageControl {
            pageControl?.backgroundColor = .clear
            pageControl?.pageIndicatorTintColor = .darkGray
            pageControl?.currentPageIndicatorTintColor = .black
        }
        launching()
    }
    
    deinit {
        
        print("InformativePageViewController DELETED.")
    }
    
    // MARK: Methods
    func pageControl(configure: ()->()) {
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                pageControl = view as? UIPageControl
                configure()
            }
        }
    }
    
    func launching() {
        
        guard let info = pageViewControllers.first, let login = pageViewControllers.last else { return }
        firstTime ? show(controller: info, hidePages: false) : show(controller: login, hidePages: true)
    }
    
    private func show(controller: UIViewController, hidePages: Bool) {
        
        pageControl?.isHidden = hidePages
        return setViewControllers([controller], direction: .forward, animated: true) { _ in }
    }
}

extension InformativePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: UIPageViewControllerDataSource
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
    
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentViewController = pageViewController.viewControllers?[0] else { return }
        
        if currentViewController is LoginViewController {
            pageControl?.isHidden = true
        } else {
            pageControl?.isHidden = false
        }
    }
}
