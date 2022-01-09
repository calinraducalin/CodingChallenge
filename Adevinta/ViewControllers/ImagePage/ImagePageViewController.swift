//
//  ImagePageViewController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit
import SwiftUI

final class ImagePageViewController: UIViewController {

    let viewModel: ImagePageViewModel
    private lazy var contentViewController = UIHostingController(
        rootView: ImagePageView(imageUris: viewModel.imageUris, selectedUri: viewModel.initialUri)
    )

    init(viewModel: ImagePageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

private extension ImagePageViewController {

    func setupView() {
        setupContentView()
        setupDismissButton()
    }

    func setupContentView() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.activateEdgeConstraints()
        contentViewController.didMove(toParent: self)
    }

    func setupDismissButton() {
        let dismissAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        navigationItem.rightBarButtonItem = .init(systemItem: .close, primaryAction: dismissAction)
    }

}
