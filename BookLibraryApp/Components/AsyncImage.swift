//
//  AsyncImage.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/12/22.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(url: String, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: url)!, cache: Environment(\.imageCache).wrappedValue))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
