//
//  ReportTableViewCell.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reportTableCellImageView: UIImageView!
    @IBOutlet weak var reportTableCellMainLabel: UILabel!
    @IBOutlet weak var reportTableCellNameLabel: UILabel!
    @IBOutlet weak var reportTableCellLocation: UILabel!
    
    var viewModel: ReportTableCellViewModel? {
        didSet { // Since viewDidLoad is only available in Controllers, could use awakeFromNib()
            bindViewModel() // BUT by leveraging didSet, I can keep it simple and works just as well
        }
    }
    
    func bindViewModel() {
        self.reportTableCellImageView.image  = self.viewModel?.image
        self.reportTableCellMainLabel.attributedText = self.viewModel?.titleText
        self.reportTableCellNameLabel.attributedText = self.viewModel?.nameText
        self.reportTableCellLocation.attributedText = self.viewModel?.locationText
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
