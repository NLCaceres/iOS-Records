//
//  CreateReportCollectionViewDelegate.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

// MARK: UICollectionViewDelegate
extension CreateReportCollectionView {
    // Segue to actual createReport view on tap of HealthPractice type button
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedCell = collectionView.cellForItem(at: indexPath) as! MakeNewReportCell
        self.performSegue(withIdentifier: "CreateReportSegue", sender: clickedCell)
    }
}

// MARK: - CollectionView FlowLayout Delegate
// Common way to use extension keyword, add conformance to a Delegate
extension CreateReportCollectionView: UICollectionViewDelegateFlowLayout {
    
    var sectionInsets: UIEdgeInsets { UIEdgeInsets(top: 25.0, left: 50.0, bottom: 25.0, right: 50.0) }
    var itemsPerRow: CGFloat { 2 }
    
    // Layout size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Establishes padding (basic algebra in a sense). See following example calculation
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) // 50 * (2 + 1) = 150 currently
        let availableWidth = view.frame.width - paddingSpace // Ex: 414 (iPhone 11 width) - 150 = 264
        let widthPerItem = availableWidth / itemsPerRow // 264 / 2 = 132
        
        return CGSize(width: widthPerItem + 20, height: widthPerItem)
    }
    
    // Space between each cell. ALSO the space between the first row of cells and the section header as well as the last row of cells and the footer
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Space between each row of cells in a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }
}
