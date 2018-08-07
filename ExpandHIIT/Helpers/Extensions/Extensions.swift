//
//  Extensions.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

// inserted by Melody
extension UIColor {
    struct TColor {
        static var shortRest: UIColor {
            return UIColor(named: "orangeYellow")!
        }
        static var longRest: UIColor {
            return UIColor(named: "offWhite")!
        }
        static var work: UIColor {
            return UIColor(named: "pastelGreen")!
        }
    }
}
