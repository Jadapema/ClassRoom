//
//  responsesTableViewCell.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 12/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class responsesTableViewCell: UITableViewCell {

    @IBOutlet var BG: UIView!
    @IBOutlet var Response: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sizeToFit()
        layoutIfNeeded()
    }

}
