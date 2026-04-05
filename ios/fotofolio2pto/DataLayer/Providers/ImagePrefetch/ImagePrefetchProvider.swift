//
//  ImagePrefetchProvider.swift
//  fotofolio2pto
//
//  Created by k r y š t o f on 05.04.2026.
//

import Foundation

protocol ImagePrefetchProvider {
    func startPrefetching(urls: [URL])
    func stopPrefetching(urls: [URL])
}
