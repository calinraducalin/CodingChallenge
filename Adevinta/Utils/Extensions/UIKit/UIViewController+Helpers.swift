//
//  UIViewController+Helpers.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit

extension UIViewController {

    func addChildViewController(_ childController: UIViewController) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.view.activateEdgeConstraints()
        childController.didMove(toParent: self)

        childController.view.alpha = 0
        UIView.animate(withDuration: 0.3, delay: .zero, options: .transitionCrossDissolve) {
            childController.view.alpha = 1
        }
    }

    func removeAsChild() {
        view.alpha = 1
        UIView.animate(withDuration: 0.3, delay: .zero, options: .transitionCrossDissolve) {
            self.view.alpha = 0
        } completion: { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

}
