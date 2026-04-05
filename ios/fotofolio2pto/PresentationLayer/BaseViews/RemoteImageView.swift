//
//  RemoteImageView.swift
//  fotofolio2pto
//
//  Created by Codex on 04.04.2026.
//

import SwiftUI
import NukeUI

struct RemoteImageView<Placeholder: View>: View {
    let urlString: String
    let contentMode: ContentMode
    private let placeholder: () -> Placeholder

    init(
        urlString: String,
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.urlString = urlString
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        if let url = makeURL(from: urlString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            LazyImage(url: url) { state in
                ZStack {
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .transition(.opacity)
                    } else {
                        placeholder()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: state.image != nil)
            }
        } else {
            placeholder()
        }
    }

    private func makeURL(from rawURL: String) -> URL? {
        if let url = URL(string: rawURL) {
            return url
        }

        guard let encodedURL = rawURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return nil
        }

        return URL(string: encodedURL)
    }
}
