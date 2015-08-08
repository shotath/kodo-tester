//
//  TopViewController.swift
//  kodo-tester
//
//  Created by shota_th on 2015/08/02.
//  Copyright (c) 2015年 s.kurihara. All rights reserved.
//

import UIKit

private let ImageSelectionSegue = "ImageSelectionSegue"
private let WaitingCheckSegue = "WaitingCheckSegue"
private let CheckSegue = "CheckSegue"

class TopViewController: UIViewController {
    
    // MARK: - Life cycles
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        performSegueWithIdentifier(ImageSelectionSegue, sender: nil)
    }


}

