//
//  MemeTableViewCell.swift
//  PhotoPicker
//
//  Created by Mitul Manish on 10/07/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
