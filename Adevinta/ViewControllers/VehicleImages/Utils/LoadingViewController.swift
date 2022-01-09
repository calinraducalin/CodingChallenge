//
//  LoadingViewController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit

final class LoadingViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        activityIndicator.activateCenterConstraints()
        activityIndicator.startAnimating()
    }

}
