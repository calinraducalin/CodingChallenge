//
//  PresenterMock.swift
//  AdevintaTests
//
//  Created by Calin Radu Calin on 10.01.2022.
//

import Foundation
@testable import Adevinta

class PresenterMock: Presenting {

    var screen: Screen!
    var presentation: Presentation!

    func show(_ screen: Screen, presentation: Presentation, animated: Bool) {
        self.screen = screen
        self.presentation = presentation
    }

}
