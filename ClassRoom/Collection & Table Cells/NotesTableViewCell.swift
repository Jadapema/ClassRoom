//
//  NotesTableViewCell.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 8/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    @IBOutlet var BGView: UIView!
    @IBOutlet var NoteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        sizeToFit()
        layoutIfNeeded()
    }
    
}
