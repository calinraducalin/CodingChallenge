//
//  MockError.swift
//  AdevintaTests
//
//  Created by Calin Radu Calin on 10.01.2022.
//

import Foundation

enum MockError: Error {
    case testError
}

extension MockError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .testError:
            return "Test Error Description"
        }
    }
}
