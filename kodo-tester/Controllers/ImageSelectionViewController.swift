//
//  ImageSelectionViewController.swift
//  kodo-tester
//
//  Created by shota_th on 2015/08/02.
//  Copyright (c) 2015年 s.kurihara. All rights reserved.
//

import UIKit

private let SearchSegue = "SearchSegue"

class ImageSelectionViewController: UIViewController {
    
    @IBOutlet private weak var nameLabelA: UILabel!
    @IBOutlet private weak var imageViewA: UIImageView!
    @IBOutlet private weak var addButtonA: UIButton!
    @IBOutlet private weak var nameLabelB: UILabel!
    @IBOutlet private weak var imageViewB: UIImageView!
    @IBOutlet private weak var addButtonB: UIButton!
    @IBOutlet private weak var okButton: UIButton!
    
    var selectedImage: UIImage?
    
    private var selectedImageView: UIImageView?
    
    // MARK: - Life cycles
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonA.tag = 0
        addButtonB.tag = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedImage = selectedImage,
           let selectedImageView = selectedImageView {
            selectedImageView.image = selectedImage
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let vc = segue.destinationViewController as? SearchImageViewController {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        }
    }
    
    // MARK: - Button actions
    
    @IBAction func okButtonAction(sender: AnyObject) {
    }

    @IBAction func addButtonAction(sender: UIButton) {
        if sender.tag == 0 {
            selectedImageView = imageViewA
        }
        else {
            selectedImageView = imageViewB
        }
        performSegueWithIdentifier(SearchSegue, sender: nil)
    }
}
