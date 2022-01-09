//
//  ImageView.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import SwiftUI
import Kingfisher

struct ImageView: View {

    let uri: String
    private var url: URL? { ImageUrlMaker(uri: uri).largePhotoUrl }

    var body: some View {
        KFImage(url)
            .placeholder { Image(systemName: "car") }
            .resizable()
            .scaledToFit()
    }

}
