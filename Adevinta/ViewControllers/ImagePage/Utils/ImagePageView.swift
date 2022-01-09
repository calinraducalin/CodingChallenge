//
//  ImagePageView.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 09.01.2022.
//

import SwiftUI

struct ImagePageView: View {

    let imageUris: [String]
    @State var selectedUri: String

    var body: some View {
        let items = imageUris.map { ImageItem(uri: $0) }
        TabView(selection: $selectedUri) {
            ForEach(items) {
                ImageView(uri: $0.uri).tag($0.uri)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
