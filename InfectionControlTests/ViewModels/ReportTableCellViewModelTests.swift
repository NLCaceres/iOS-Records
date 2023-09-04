//
//  ReportTableCellViewModelTests.swift
//  InfectionControlTests
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

@testable import InfectionControl
import XCTest

class ReportTableCellViewModelTests: XCTestCase {
    var report: Report!
    var cellViewModel: ReportTableCellViewModel!
    
    override func setUp() {
        report = ModelsFactory.createReport()
        cellViewModel = ReportTableCellViewModel(report: report)
        Report.dateFormatter.locale = Locale(identifier: "en_US")
    }
    
    func testViewCellImage() { // Check we setup our viewModel properly
        XCTAssertEqual(cellViewModel.image, #imageLiteral(resourceName: "report_placeholder_icon"))
    }
    
    func testViewCell() { // Checks didSet on the ViewCell itself from the viewModel side!
        // Setup Cell UIViews itself
        let reportCell = ReportTableViewCell()
        // Keep strong refs to our UIViews or they'll dealloc being weak refs in the ViewCell
        let myImageView = UIImageView()
        reportCell.reportTableCellImageView = myImageView
        let myMainLabel = UILabel()
        reportCell.reportTableCellMainLabel = myMainLabel
        let myNameLabel = UILabel()
        reportCell.reportTableCellNameLabel = myNameLabel
        let myLocationLabel = UILabel()
        reportCell.reportTableCellLocation = myLocationLabel
        
        // WHEN viewModel gets set
        reportCell.viewModel = cellViewModel
        // THEN the UIViews should match the viewModels values
        XCTAssertEqual(reportCell.reportTableCellImageView.image, cellViewModel.image)
        
        XCTAssertEqual(reportCell.reportTableCellMainLabel.text, cellViewModel.titleText.string)
        XCTAssertEqual(reportCell.reportTableCellMainLabel.attributedText?.string, cellViewModel.titleText.string)
        
        XCTAssertEqual(reportCell.reportTableCellNameLabel.text, cellViewModel.nameText.string)
        XCTAssertEqual(reportCell.reportTableCellNameLabel.attributedText?.string, cellViewModel.nameText.string)
        
        XCTAssertEqual(reportCell.reportTableCellLocation.text, cellViewModel.locationText.string)
        XCTAssertEqual(reportCell.reportTableCellLocation.attributedText?.string, cellViewModel.locationText.string)
    }
    
    func testCreateTitleText() {
        let healthPracticeName = "\(self.report.healthPractice.name)"
        let dateStr = "10/1/20" // MockDate ALWAYS this date. CellViewModel uses Report's default short date format
        let fullStr = "\(healthPracticeName) Violation \(dateStr)"
        let mainText = cellViewModel.titleText
        XCTAssertTrue(mainText.mutableString.hasPrefix(healthPracticeName))
        XCTAssertTrue(mainText.mutableString.hasSuffix(dateStr))
        XCTAssertEqual(mainText.string, fullStr)
    }
    func testCreateNameText() {
        let commitStr = "Committed by: "
        let employeeStr = "\(self.report.employee.firstName) \(self.report.employee.surname)"
        let fullStr = commitStr + employeeStr
        let nameText = cellViewModel.nameText
        XCTAssertTrue(nameText.mutableString.hasPrefix(commitStr))
        XCTAssertTrue(nameText.mutableString.hasSuffix(employeeStr))
        XCTAssertEqual(nameText.string, fullStr)
    }
    func testCreateLocationText() {
        let locationPrefix = "Location: "
        let locationStr = "\(self.report.location.facilityName) Unit \(self.report.location.unitNum) Room \(self.report.location.roomNum)"
        let fullStr = locationPrefix + locationStr
        let locationText = cellViewModel.locationText
        XCTAssertTrue(locationText.mutableString.hasPrefix(locationPrefix))
        XCTAssertTrue(locationText.mutableString.hasSuffix(locationStr))
        XCTAssertEqual(locationText.string, fullStr)
    }
}
