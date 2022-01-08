//
//  NetworkController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: AnyObject {
    typealias Headers = [String: Any]
    func get<T>(url: URL) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkController: NetworkControllerProtocol {

    func get<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
