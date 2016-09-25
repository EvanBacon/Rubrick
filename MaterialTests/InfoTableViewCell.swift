//
//  InfoTableViewCell.swift
//  Prototype
//
//  Created by Evan Bacon on 12/2/15.
//  Copyright © 2015 Evan Bacon. All rights reserved.
//

import Foundation
import UIKit

class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var body: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setColor(color: UIColor ) {
        self.backgroundColor = color
        title.textColor = color.contrast()
                body.textColor = color.contrast()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}