//
//  dropdownTableViewCell.swift
//  PhotoViewer
//
//  Created by Admin on 18/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class dropdownTableViewCell: UITableViewCell {

   
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var socialNetworkTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
