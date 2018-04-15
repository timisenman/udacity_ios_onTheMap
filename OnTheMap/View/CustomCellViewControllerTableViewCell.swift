//
//  CustomerCellViewControllerTableViewCell.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/12/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class CustomCellViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentSite: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
