//
//  CreateReportCollectionVC+CVDataSource.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import Foundation
import UIKit

// MARK: UICollectionViewDataSource
extension CreateReportCollectionView {
    
    // Number of sections (areas with titles followed by buttons)
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Two Precaution Types: Quarantine and Normal
        return self.precautions.count
    }
    
    // Number of buttons per section
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        guard let healthPractices = self.precautions[section].practices else {
            return 0 // if arr == 0
        }
        return healthPractices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell setup
        let sectionNum = indexPath.section
        let cellNum = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MakeNewReportCell",
                                                      for: indexPath) as! MakeNewReportCell
        cell.reportTypeImageView.image = #imageLiteral(resourceName: "plus_icon")
        cell.reportTypeImageView.layer.masksToBounds = true
        cell.reportTypeImageView.layer.cornerRadius = cell.bounds.width / 2
        
        if let healthPractices = self.precautions[sectionNum].practices {
            cell.reportTypeLabel.text = healthPractices[cellNum].name
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        // Using delegate method element kind
        switch kind {
        // By using headers in attributes section for collectionView you get this available
        case UICollectionView.elementKindSectionHeader:
            // Checking that a sectionHeader of our custom type exists and customize it
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "ReportTypeSectionHeader", for: indexPath) as? ReportSectionReusableView
                else { fatalError("Invalid view type") }
            
            if (precautions.isEmpty) { return headerView } // Return early since no unused section needed
            
            headerView.backgroundColor = UserDefaults.standard.color(forKey: "themeSecondaryColor")
            let sectionNum = indexPath.section
            headerView.headerLabel.text = "\(precautions[sectionNum].name) Precautions"
            headerView.headerLabel.textColor = UserDefaults.standard.color(forKey: "themeColor")
            return headerView
            
        default: // If made it here, a very unexpected view made it here
            assert(false, "Invalid element type")
        }
    }
}
