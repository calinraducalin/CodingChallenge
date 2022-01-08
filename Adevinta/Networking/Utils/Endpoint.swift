//
//  Endpoint.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation

struct Endpoint {
    let path: String
}

extension Endpoint {
    func makeURL() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "m.mobile.de"
        components.path = path

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}
