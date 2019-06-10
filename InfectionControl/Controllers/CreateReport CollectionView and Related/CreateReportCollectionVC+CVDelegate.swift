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
        let clickedCell = collectionView.cellForItem(at: indexPath) as! ReportCell
        self.performSegue(withIdentifier: segueIdentifier, sender: clickedCell)
    }
}
