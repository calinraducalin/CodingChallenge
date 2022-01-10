//
//  ActivityIndicatorMock.swift
//  AdevintaTests
//
//  Created by Calin Radu Calin on 10.01.2022.
//

import UIKit

class ActivityIndicatorMock: UIActivityIndicatorView {

    var startAnimatingCalled = false
    var stopAnimatingCalled = false

    override func startAnimating() {
        startAnimatingCalled = true
    }

    override func stopAnimating() {
        stopAnimatingCalled = true
    }

}
