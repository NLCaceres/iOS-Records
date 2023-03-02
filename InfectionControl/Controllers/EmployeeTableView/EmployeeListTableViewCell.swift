//
//  EmployeeListTableViewCell.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

class EmployeeListTableViewCell: UITableViewCell, BaseStyling {

    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeProfessionLabel: UILabel!
    
    static let identifier = "EmployeeListTableViewCell" // Used in dequeueReusableCell(withIdentifier:)
    
    var viewModel: EmployeeListTableCellViewModel! {
        didSet { setupViews() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCellStyle()
    }
    
    private func setupCellStyle() {
        // Normal styling
        backgroundColor = themeColor.withAlphaComponent(0.7) // Use Base Styling themeColor property
        
        // On Selection Styling
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = themeColor.withAlphaComponent(0.7)
        selectedBackgroundView = selectedBackground
    }
    
    private func setupViews() {
        employeeNameLabel.highlightedTextColor = self.themeSecondaryColor // \.highlightedTextColor is the On Selection Styling
        employeeProfessionLabel.highlightedTextColor = self.themeSecondaryColor.withAlphaComponent(0.9)
        
        employeeNameLabel.text = viewModel.employeeFullName // Formatted as "\(firstName) \(surname)"
        employeeProfessionLabel.text = viewModel.employeeProfession // Formatted to "\(occupation) \(discipline)"
        // It's a bit simpler to let reassigning the "viewModel" run its "didSet" so a new value can be set to UILabel's "text"
        // Rather than replacing "didSet" with an "published.assignOn(\.text, uiLabel).store(&cancellables)"
        // TODO: Compare "didSet" vs "assignOn()"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
