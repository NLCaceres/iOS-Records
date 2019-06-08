//
//  EmployeeListTableViewCell.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/31/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import UIKit

class EmployeeListTableViewCell: UITableViewCell {

    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeProfessionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
