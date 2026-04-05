//
//  NukeImagePrefetchProvider.swift
//  fotofolio2pto
//
//  Created by k r y š t o f on 05.04.2026.
//

import Foundation
import Nuke

final class NukeImagePrefetchProvider: ImagePrefetchProvider {

    private let prefetcher = ImagePrefetcher()

    func startPrefetching(urls: [URL]) {
        prefetcher.startPrefetching(with: urls)
    }

    func stopPrefetching(urls: [URL]) {
        prefetcher.stopPrefetching(with: urls)
    }
}
