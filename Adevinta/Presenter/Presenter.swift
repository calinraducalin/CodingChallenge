//
//  Presenter.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit

enum Presentation {
    case push
    case present
}

protocol Presenting {
    func show(_ screen: Screen, presentation: Presentation, animated: Bool)
}

class Presenter: Presenting {

    unowned let originViewController: UIViewController

    init(originViewController: UIViewController) {
        self.originViewController = originViewController
    }

    func show(_ screen: Screen, presentation: Presentation, animated: Bool = true) {
        let viewController = screen.makeViewController()

        switch presentation {
        case .push:
            originViewController.navigationController?.pushViewController(viewController, animated: animated)
        case .present:
            originViewController.present(viewController, animated: animated)
        }
    }
}
