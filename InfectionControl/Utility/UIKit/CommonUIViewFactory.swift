//
//  CommonViewFactory.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import UIKit

// MARK: RefreshControl
func setUpRefreshControl(title: String) -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.red
    refreshControl.attributedTitle = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.red])
    return refreshControl
}
// Since it returns the control, on YOU to properly assign it to a scrollView, tableView or collectionView
func setUpRefreshControl(title: String, view: UIViewController, action: Selector) -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.red
    // Use action as #selector(someFunc) or #selector(someFunc(_:)), e.g. someFunc(_ sender: Any) or someFunc(_ sender: Any? = nil)
    refreshControl.addTarget(view, action: action, for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.red])
    return refreshControl
}
