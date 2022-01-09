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
    lazy var contentViewController = UIHostingController(rootView: ImagePageView(imageUris: viewModel.imageUris, selectedUri: viewModel.initialUri))

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

struct ImagePageViewModel {

    let initialUri: String
    let imageUris: [String]

}

private extension ImagePageViewController {

    func setupView() {
        setupContentView()
    }

    func setupContentView() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.activateEdgeConstraints()
    }

}
