//
//  FeedViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI

final class FeedViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    // UCs
    
    private weak var flowController: FeedFlowController?
    
    // MARK: Init
    
    init(
        flowController: FeedFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()

        fetchPortfolios()
    }
    
    // MARK: State
    
    struct State {
        var isLoading: Bool = false
        var portfolios: [Portfolio] = []
        var isFiltering: Bool = false
        var arrowAngle: Int = 0
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchPortfolios
        case sortByDate
        case sortByRating
        case filter
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchPortfolios: fetchPortfolios()
            case .sortByDate: withAnimation { sortByDate() }
            case .sortByRating: withAnimation { sortByRating() }
            case .filter: showFilter()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchPortfolios() {
        state.isLoading = true
        defer { state.isLoading.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            withAnimation {
                self?.state.portfolios = Portfolio.sampleData
            }
        }
    }
    
    private func sortByDate() {
        
    }
    
    private func sortByRating() {
        
    }
    
    private func showFilter() {
        flowController?.presentFilter()
    }
}

struct IImage: Identifiable {
    let id = UUID()
    var src: MyImageEnum
}

enum MyImageEnum {
    case remote(URL)
    case local(Image)
}
