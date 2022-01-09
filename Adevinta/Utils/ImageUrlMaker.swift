//
//  ImageUrlMaker.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import Foundation

struct ImageUrlMaker {
    let uri: String
}

extension ImageUrlMaker {
    var thumbnailUrl: URL? { URL(string: "https://\(uri)_2.jpg") }
    var largePhotoUrl: URL? { URL(string: "https://\(uri)_27.jpg") }
}
