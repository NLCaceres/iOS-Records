//
//  CreateReportCollectionVC+CVDelegate.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/22/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import Foundation
import UIKit

// MARK: UICollectionViewDelegate
extension CreateReportCollectionView {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let segueIdentifier = "CreateReportSegue"
        let clickedCell = collectionView.cellForItem(at: indexPath) as! ReportCell
        print("This is the cell that got clicked \(clickedCell.reportCellLabel.text!)")
        print("We clicked something at \(indexPath.item)")
        self.performSegue(withIdentifier: segueIdentifier, sender: clickedCell)
    }
}
