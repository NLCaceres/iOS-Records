//
//  ReportTableViewCell.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/7/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reportTableCellImageView: UIImageView!
    @IBOutlet weak var reportTableCellMainLabel: UILabel!
    @IBOutlet weak var reportTableCellNameLabel: UILabel!
    @IBOutlet weak var reportTableCellLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
