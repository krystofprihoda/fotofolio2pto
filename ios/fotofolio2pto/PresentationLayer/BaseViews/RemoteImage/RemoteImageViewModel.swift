//
//  RemoteImageViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.04.2025.
//


import Resolver
import SwiftUI

final class RemoteImageViewModel: BaseViewModel, ObservableObject {
    
    // MARK: Dependencies

    @LazyInjected private var readRemoteImageUseCase: ReadRemoteImageUseCase

    // MARK: State

    struct State {
        var urlString: String = ""
        var isLoading: Bool = true
        var imageSrc: UIImage? = nil
        var error: Error? = nil
    }

    @Published private(set) var state = State()

    // MARK: Init
    
    init(url: String) {
        super.init()
        state.urlString = url
        executeTask(Task {
            await fetchImage()
        })
    }
    
    // MARK: Intent
    
    enum Intent {
        case retryFetchingImage
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .retryFetchingImage:
                await fetchImage()
            }
        })
    }

    // MARK: Methods

    private func fetchImage() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            let image = try await readRemoteImageUseCase.execute(url: state.urlString)
            state.imageSrc = image
            state.error = nil
        } catch {
            state.imageSrc = nil
            state.error = error
        }
    }
}
