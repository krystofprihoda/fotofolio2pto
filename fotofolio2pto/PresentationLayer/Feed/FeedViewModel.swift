//
//  FeedViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

public protocol FeedTabBadgeDelegate: AnyObject {
    func updateCount(to: Int, animated: Bool)
}

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
        flowController: FeedFlowController?,
        signedInUser: String
    ) {
        self.flowController = flowController
        super.init()
        state.signedInUser = signedInUser
        
        executeTask(Task { await fetchPortfolios(isRefreshing: false) })
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        fetchFlaggedPortfolios()
        
        if state.portfolios.isEmpty {
            executeTask(Task { await fetchPortfolios(isRefreshing: false) })
        }
        
        flowController?.feedTabBadgeDelegate?.updateCount(to: state.flaggedPortfolioIds.count, animated: false)
    }
    
    // MARK: State
    
    struct State {
        var signedInUser = ""
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var portfolios: [Portfolio] = []
        var flaggedPortfolioIds: [Int] = []
        var filter: [String] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchPortfolios(isRefreshing: Bool)
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
            case .fetchPortfolios(let isRefreshing): await fetchPortfolios(isRefreshing: isRefreshing)
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
    
    private func fetchPortfolios(isRefreshing: Bool) async {
        if isRefreshing {
            state.isRefreshing = true
        } else {
            state.isLoading = true
        }
        
        defer {
            if isRefreshing {
                state.isRefreshing = false
            } else {
                state.isLoading = false
            }
        }
        
        do {
            state.portfolios = try await getAllPortfolios.execute()
        } catch {
            // handle error
        }
    }
    
    private func fetchPortfoliosSortedBy(_ sortBy: SortByEnum) async {
        state.isRefreshing = true
        defer { state.isRefreshing.toggle() }
        
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
            
            flowController?.feedTabBadgeDelegate?.updateCount(to: state.flaggedPortfolioIds.count, animated: true)
        } catch {
        
        }
    }
    
    private func unflagPortfolio(withId id: Int) {
        do {
            try unflagPortfolioUseCase.execute(id: id)
            fetchFlaggedPortfolios()
            
            flowController?.feedTabBadgeDelegate?.updateCount(to: state.flaggedPortfolioIds.count, animated: false)
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

extension FeedViewModel: FilterFeedDelegate {
    func filterFeedPortfolios(_ filter: [String]) async {
        state.isRefreshing = true
        defer { state.isRefreshing.toggle() }
        
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

public struct IImage: Identifiable, Equatable {
    public static func == (lhs: IImage, rhs: IImage) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id = UUID()
    public var src: MyImageEnum
}

public enum MyImageEnum {
    case remote(URL)
    case local(Image)
}
