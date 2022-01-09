//
//  VehicleImageItem.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation

struct VehicleImageItem: Hashable {
    let uri: String

    var url: URL? { ImageUrlMaker(uri: uri).thumbnailUrl }
}
