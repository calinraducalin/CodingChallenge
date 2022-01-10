//
//  VehicleDetailsControllerMock.swift
//  AdevintaTests
//
//  Created by Calin Radu Calin on 10.01.2022.
//

import Combine
@testable import Adevinta

class VehicleDetailsControllerMock: VehicleDetailsControllerProtocol {
    let errorId = "-1"
    let emptyImagesId = "0"
    let imagesId = "1"
    let networkController: NetworkControllerProtocol = NetworkController()

    func getVehicleDetails(id: String) -> AnyPublisher<VehicleDetails, Error> {
        switch id {
        case errorId:
            return makeErrorFuture()
        case emptyImagesId:
            return makeSuccessFutureEmptyImages()
        default:
            return makeSuccessFutureImages()
        }
    }

    func makeErrorFuture() -> AnyPublisher<VehicleDetails, Error> {
        return Deferred {
            Future { promise in
                promise(.failure(MockError.testError))
            }
        }.eraseToAnyPublisher()
    }

    func makeSuccessFutureEmptyImages() -> AnyPublisher<VehicleDetails, Error> {
        return Deferred {
            Future { promise in
                promise(.success(VehicleDetails(images: [])))
            }
        }.eraseToAnyPublisher()
    }

    func makeSuccessFutureImages() -> AnyPublisher<VehicleDetails, Error> {
        return Deferred {
            Future { promise in
                promise(.success(VehicleDetails(images: [
                    VehicleDetails.Image(uri: "test0"),
                    VehicleDetails.Image(uri: "test1"),
                    VehicleDetails.Image(uri: "test2")
                ])))
            }
        }.eraseToAnyPublisher()
    }

}
