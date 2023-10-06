//
//  CreateReportCollectionViewDataSource.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

// MARK: UICollectionViewDataSource
extension CreateReportCollectionView {
    
    // Number of sections (areas with titles followed by cells/buttons)
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Two Precaution Types: Standard and Isolation
        return self.precautions.count
    }
    
    // Number of cells/buttons per section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let healthPractices = self.precautions[section].practices else {
            return 0 // Array is nil so return an no sections needed
        }
        // CDC generally states there are 2 - 8 Standard Precautions and 3-4 Isolation/Transmission precautions
        return healthPractices.count // So expecting at least 5 cells total divided by 2 sections
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell setup
        let sectionNum = indexPath.section
        let cellNum = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MakeNewReportCell", for: indexPath) as! MakeNewReportCell
        
        cell.reportTypeImageView.image = #imageLiteral(resourceName: "plus_icon")
        cell.reportTypeImageView.layer.masksToBounds = true
        cell.reportTypeImageView.layer.cornerRadius = cell.bounds.width / 2
        
        if let healthPractices = self.precautions[sectionNum].practices {
            cell.reportTypeLabel.text = healthPractices[cellNum].name
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind { // This "kind" param lets us search for the Header
        // By using headers in attributes section for collectionView you can find it via the following enum
        case UICollectionView.elementKindSectionHeader:
            // THEN finally check if the sectionHeader matches our custom type and initialize it
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "ReportTypeSectionHeader",
                                                                                   for: indexPath) as? ReportSectionReusableView
            else { fatalError("Invalid view type") }
            
            if (precautions.isEmpty) { return headerView } // Return early since shouldn't render unused/unneeded sections
            
            headerView.backgroundColor = UserDefaults.standard.color(forKey: "themeSecondaryColor")
            
            let sectionNum = indexPath.section
            headerView.headerLabel.text = "\(precautions[sectionNum].name) Precautions"
            headerView.headerLabel.textColor = UserDefaults.standard.color(forKey: "themeColor")
            
            return headerView
            
        default: // If made it here, unexpected view was rendered
            assert(false, "Invalid element type")
        }
    }
}
