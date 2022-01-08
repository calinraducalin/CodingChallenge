//
//  UIView+Helpers.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit

extension UIView {

    func activateEdgeConstraints(
        relativeTo view: UIView? = nil,
        bottomConstraintPriority: UILayoutPriority = .required
    ) {
        guard let relativeView = view ?? superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = bottomAnchor.constraint(equalTo: relativeView.bottomAnchor)
        bottomConstraint.priority = bottomConstraintPriority
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: relativeView.topAnchor),
            leadingAnchor.constraint(equalTo: relativeView.leadingAnchor),
            trailingAnchor.constraint(equalTo: relativeView.trailingAnchor),
            bottomConstraint
        ])
    }

}
