//
//  InformativeViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 12/13/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class InformativeViewController: UIViewController {

    // MARK: Properties
    var firstTime = false
    fileprivate lazy var pages: [UIViewController] = {
        return NavigationManager.shared.informativePages
    }()
    
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var skipButton: UIButton!
    @IBOutlet fileprivate weak var nextButton: UIButton!

    // The UIPageViewController
    fileprivate var pageContainer: UIPageViewController!
    
    // Track the current index
    fileprivate var currentIndex: Int?
    fileprivate var pendingIndex: Int?
    
    var nextPageIndex: Int {
        return currentIndex! + 1 ?? 0
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        launching()
        
        // Add it to the view
        view.addSubview(pageContainer.view)
        
        // Configure our custom pageControl
        view.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        view.bringSubview(toFront: skipButton)
        view.bringSubview(toFront: nextButton)
    }
    
    // MARK: Actions
    @IBAction func skipButtonPressed(_ sender: UIButton) {
    
        guard let login = pages.last else { return }
        show(controller: login, hideElements: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
   
        guard let index = currentIndex else { return }
        
        if index == 0 {
            show(controller: pages[nextPageIndex], hideElements: false)
            nextPage()
        } else if index == pages.count - 2 {
            show(controller: pages[nextPageIndex], hideElements: true)
            nextPage()
        } else {
            show(controller: pages[nextPageIndex], hideElements: false)
            nextPage()
        }
    }

    // MARK: Methods
    private func launching() {
        
        guard let info = pages.first, let login = pages.last else { return }
        firstTime ? show(controller: info, hideElements: false) : show(controller: login, hideElements: true)
    }
    
    private func show(controller: UIViewController, hideElements: Bool) {
        
        hide(elements: hideElements)
        return pageContainer.setViewControllers([controller], direction: .forward, animated: true) { _ in }
    }
    
    fileprivate func hide(elements: Bool) {
        
        pageControl.isHidden = elements
        skipButton.isHidden = elements
        nextButton.isHidden = elements
    }
    
    private func nextPage() {
        
        pageControl.currentPage = nextPageIndex
        currentIndex! += 1
    }
}

extension InformativeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
       
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
        
        guard let currentViewController = pageViewController.viewControllers?[0] else { return }
        currentViewController is LoginViewController ? hide(elements: true) : hide(elements: false)
    }
}
