//
//  VehicleDetailsController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation
import Combine

protocol VehicleDetailsControllerProtocol: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func getVehicleDetails(id: String) -> AnyPublisher<VehicleDetails, Error>
}

final class VehicleDetailsController: VehicleDetailsControllerProtocol {

    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func getVehicleDetails(id: String) -> AnyPublisher<VehicleDetails, Error> {
        let endpoint = Endpoint.vehicleDetails(id: id)
        return networkController.get(url: endpoint.makeURL())
    }
}

private extension Endpoint {

    static func vehicleDetails(id: String) -> Self {
        return Endpoint(path: "/svc/a/\(id)")
    }

}
