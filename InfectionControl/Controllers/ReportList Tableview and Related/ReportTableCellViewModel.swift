//
//  ReportTableCellViewModel.swift
//  InfectionControl
//
//  Created by Nick Caceres on 5/22/19.
//  Copyright © 2019 Nick Caceres. All rights reserved.
//

import Foundation
import UIKit

class ReportTableCellViewModel: NSObject {
    
    // PROPERTIES
    var image: UIImage
    // Title and date are actually same UILabel
    var titleText: NSMutableAttributedString
    var nameText: NSMutableAttributedString
    var locationText: NSMutableAttributedString
    
    init(image: UIImage, title: NSMutableAttributedString, name: NSMutableAttributedString, location: NSMutableAttributedString) {
        self.image = image
        self.titleText = title
        self.nameText = name
        self.locationText = location
    }
    
}
