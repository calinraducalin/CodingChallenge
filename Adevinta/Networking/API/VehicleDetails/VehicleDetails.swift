//
//  VehicleDetails.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation

struct VehicleDetails: Decodable {
    struct Image: Decodable {
        let uri: String?
    }

    let images: [Image]?
}
