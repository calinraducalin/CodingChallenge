//
//  AlertScreen.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import UIKit

struct AlertScreen: Screen {

    let title: String?
    let message: String?

    func makeViewController() -> UIViewController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        return alertController
    }
}
