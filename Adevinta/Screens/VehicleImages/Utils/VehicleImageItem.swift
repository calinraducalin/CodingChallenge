//
//  VehicleImageItem.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation

struct VehicleImageItem: Hashable {
    let uri: String

    var url: URL? { URL(string: "https://\(uri)_2.jpg") }
}
