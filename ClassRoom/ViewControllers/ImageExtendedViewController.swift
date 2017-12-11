//
//  ImageExtendedViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 8/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class ImageExtendedViewController: UIViewController {

    
    @IBOutlet var UImageView: UIImageView!
    
    var selectedImageUrlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UImageView.loadImageUsingCacheWithUrlString(selectedImageUrlString)
       
    }

    @IBAction func Cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
