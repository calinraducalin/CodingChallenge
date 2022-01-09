//
//  PageImageScreen.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit

struct PageImageScreen: Screen {

    let selectedUri: String
    let imageUris: [String]

    func makeViewController() -> UIViewController {
        let viewModel = ImagePageViewModel(initialUri: selectedUri, imageUris: imageUris)
        let viewController = ImagePageViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

}
