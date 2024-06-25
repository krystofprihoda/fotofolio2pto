//
//  FeedViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

final class FeedViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var getAllPortfolios: GetAllPortfoliosUseCase
    @LazyInjected private var flagPortfolioUseCase: FlagPortfolioUseCase
    @LazyInjected private var unflagPortfolioUseCase: UnflagPortfolioUseCase
    @LazyInjected private var getFlaggedPortfoliosUseCase: GetFlaggedPortfoliosUseCase
    @LazyInjected private var getFilteredPortfoliosUseCase: GetFilteredPortfoliosUseCase
    
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
        
        fetchFlaggedPortfolios()
        
        if state.portfolios.isEmpty {
            executeTask(Task { await fetchPortfolios() })
        }
    }
    
    // MARK: State
    
    struct State {
        var isLoading: Bool = false
        var portfolios: [Portfolio] = []
        var flaggedPortfolioIds: [Int] = []
        var filter: [String] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchPortfolios
        case sortByDate
        case sortByRating
        case filter
        case flagPortfolio(Int)
        case unflagPortfolio(Int)
        case showProfile(User)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchPortfolios: await fetchPortfolios()
            case .sortByDate: await fetchPortfoliosSortedBy(.date)
            case .sortByRating: await fetchPortfoliosSortedBy(.rating)
            case .filter: showFilter()
            case .flagPortfolio(let id): flagPortfolio(withId: id)
            case .unflagPortfolio(let id): unflagPortfolio(withId: id)
            case .showProfile(let user): showProfile(user: user)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchPortfolios() async {
        state.isLoading = true
        defer { state.isLoading.toggle() }
        
        do {
            state.portfolios = try await getAllPortfolios.execute()
        } catch {
            // handle error
        }
    }
    
    private func fetchPortfoliosSortedBy(_ sortBy: SortByEnum) async {
        state.isLoading = true
        defer { state.isLoading.toggle() }
        
        do {
            state.portfolios = try await getAllPortfolios.execute(sortBy: sortBy)
        } catch {
            // handle error
        }
    }
    
    private func showFilter() {
        flowController?.presentFilter(with: state.filter)
    }
    
    private func flagPortfolio(withId id: Int) {
        do {
            try flagPortfolioUseCase.execute(id: id)
            fetchFlaggedPortfolios()
        } catch {
        
        }
    }
    
    private func unflagPortfolio(withId id: Int) {
        do {
            try unflagPortfolioUseCase.execute(id: id)
            fetchFlaggedPortfolios()
        } catch {
            
        }
    }
    
    private func fetchFlaggedPortfolios() {
        state.flaggedPortfolioIds = getFlaggedPortfoliosUseCase.execute(idOnly: true)
    }
    
    private func showProfile(user: User) {
        flowController?.showProfile(user: user)
    }
}

extension FeedViewModel: FeedFlowControllerDelegate {
    func filterFeedPortfolios(_ filter: [String]) async {
        state.isLoading = true
        defer { state.isLoading.toggle() }
        
        state.filter = filter
        
        do {
            state.portfolios = try await getFilteredPortfoliosUseCase.execute(filter: filter)
        } catch {
            
        }
    }
    
    func removeFilterTag(_ tag: String) async {
        state.filter.removeAll(where: { $0 == tag })
        await filterFeedPortfolios(state.filter)
    }
}

public struct IImage: Identifiable {
    public let id = UUID()
    public var src: MyImageEnum
}

public enum MyImageEnum {
    case remote(URL)
    case local(Image)
}
