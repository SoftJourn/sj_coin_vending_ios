//
//  QRCodeGeneratorViewController.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 12/7/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class QRCodeGeneratorViewController: UIViewController {

    // MARK: Properties

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        print("QRCodeGeneratorViewController DELETED.")
    }
    
    // MARK: Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
    
        dismiss(animated: true) { }
    }

    @IBAction func generateButtonPressed(_ sender: UIButton) {
    
    }
}
