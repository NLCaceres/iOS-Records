//
//  CreateReportCollectionVC+CVDataSource.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/23/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

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
            return 0
        }
        return healthPractices.count
    }
    
    // Blank cell for formatting
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        // Cell setup
        let sectionNum = indexPath.section
        let cellNum = indexPath.item
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReportCell
        
        cell.reportCellImageView.image = #imageLiteral(resourceName: "plus_icon")
        cell.reportCellImageView.layer.masksToBounds = true
        cell.reportCellImageView.layer.cornerRadius = cell.bounds.width / 2
        
        if let healthPractices = self.precautions[sectionNum].practices {
            cell.reportCellLabel.text = healthPractices[cellNum].name
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Using delegate method element kind
        switch kind {
        // By using headers in attributes section for collectionView you get this available
        case UICollectionView.elementKindSectionHeader:
            // Checking that a header/section exists and customize it
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "\(ReportSectionReusableView.self)",
                    for: indexPath) as? ReportSectionReusableView
                else {
                    fatalError("Invalid view type")
            }
            
            if (precautions.isEmpty) {
                return headerView
            }
            headerView.backgroundColor = UserDefaults.standard.color(forKey: "headerBackgroundColor")
            let sectionNum = indexPath.section
            headerView.headerLabel.text = "\(precautions[sectionNum].name) Precautions"
            headerView.headerLabel.textColor = UserDefaults.standard.color(forKey: "headerTextColor")
            return headerView
            
            
        default:
            // Checking that it's the right type (so in other words guard else condition)
            assert(false, "Invalid element type")
        }
    }
}
