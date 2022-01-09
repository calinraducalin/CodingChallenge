//
//  ImageItem.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import Foundation

struct ImageItem: Identifiable {
    let uri: String
    var id: String { uri }
}
