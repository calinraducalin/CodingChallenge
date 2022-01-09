//
//  UIView+Helpers.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit

extension UIView {

    func activateEdgeConstraints(relativeTo view: UIView? = nil) {
        guard let relativeView = view ?? superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: relativeView.topAnchor),
            leadingAnchor.constraint(equalTo: relativeView.leadingAnchor),
            trailingAnchor.constraint(equalTo: relativeView.trailingAnchor),
            bottomAnchor.constraint(equalTo: relativeView.bottomAnchor)
        ])
    }

    func activateSafeAreaConstraints(relativeTo view: UIView? = nil) {
        guard let layoutGuide = (view ?? superview)?.safeAreaLayoutGuide else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
    }

    func activateCenterConstraints(relativeTo view: UIView? = nil) {
        guard let relativeView = view ?? superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: relativeView.centerXAnchor),
            centerYAnchor.constraint(equalTo: relativeView.centerYAnchor)
        ])
    }

}
