//
//  FeedViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

public protocol TabBadgeFlowDelegate: AnyObject {
    func updateCount(of: MainTab, to: Int, animated: Bool)
}

final class FeedViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var readAllPortfoliosUseCase: ReadAllPortfoliosUseCase
    @LazyInjected private var flagPortfolioUseCase: FlagPortfolioUseCase
    @LazyInjected private var unflagPortfolioUseCase: UnflagPortfolioUseCase
    @LazyInjected private var readFlaggedPortfoliosUseCase: ReadFlaggedPortfoliosUseCase
    @LazyInjected private var readUserDataByCreatorIdUseCase: ReadUserDataByCreatorIdUseCase
    
    private weak var flowController: FeedFlowController?
    
    // MARK: Init
    
    init(
        flowController: FeedFlowController?,
        signedInUserId: String
    ) {
        self.flowController = flowController
        super.init()
        state.signedInUserId = signedInUserId
        
        executeTask(Task { await fetchPortfolios(isRefreshing: false) })
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        fetchFlaggedPortfolios()
        
        if state.portfolios.isEmpty {
            executeTask(Task { await fetchPortfolios(isRefreshing: false) })
        }
        
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .selection, to: state.flaggedPortfolioIds.count, animated: false)
    }
    
    // MARK: State
    
    struct State: Equatable {
        var signedInUserId = ""
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var portfolios: [Portfolio] = []
        var flaggedPortfolioIds: [String] = []
        var filter: [String] = []
        var sortBy: SortByEnum = .date
        var toastData: ToastData? = nil
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchPortfolios(isRefreshing: Bool)
        case sortByDate
        case sortByRating
        case filter
        case flagPortfolio(String)
        case unflagPortfolio(String)
        case showProfile(creatorId: String)
        case setToastData(ToastData?)
        case removeCategory(String)
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
            case .showProfile(let creatorId): await showProfile(creatorId: creatorId)
            case .setToastData(let toast): setToastData(toast)
            case .removeCategory(let category): await removeFilterCategory(category)
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
            state.portfolios = try await readAllPortfoliosUseCase.execute(categories: state.filter, sortBy: state.sortBy)
        } catch {
            state.toastData = .init(message: L.Selection.portfolioLoadFailed, type: .error)
        }
    }
    
    private func fetchPortfoliosSortedBy(_ sortBy: SortByEnum) async {
        guard state.sortBy != sortBy else { return }
        
        state.sortBy = sortBy
        state.isRefreshing = true
        defer { state.isRefreshing.toggle() }
        
        do {
            state.portfolios = try await readAllPortfoliosUseCase.execute(categories: state.filter, sortBy: state.sortBy)
        } catch {
            state.toastData = .init(message: L.Selection.portfolioLoadFailed, type: .error)
        }
    }
    
    private func showFilter() {
        flowController?.presentFilter(with: state.filter)
    }
    
    private func flagPortfolio(withId id: String) {
        flagPortfolioUseCase.execute(id: id)
        fetchFlaggedPortfolios()
        
        state.toastData = .init(message: L.Feed.portfolioAdded, type: .success)
        
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .selection, to: state.flaggedPortfolioIds.count, animated: true)
    }
    
    private func unflagPortfolio(withId id: String) {
        unflagPortfolioUseCase.execute(id: id)
        fetchFlaggedPortfolios()
        
        // Show a toast
        state.toastData = .init(message: L.Feed.portfolioRemoved, type: .neutral)
        
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .selection, to: state.flaggedPortfolioIds.count, animated: false)
    }
    
    private func fetchFlaggedPortfolios() {
        state.flaggedPortfolioIds = readFlaggedPortfoliosUseCase.execute(idOnly: true)
    }
    
    private func showProfile(creatorId: String) async {
        do {
            let user = try await readUserDataByCreatorIdUseCase.execute(creatorId: creatorId)
            flowController?.showProfile(user: user)
        } catch {
            state.toastData = .init(message: L.Feed.profileLoadFailed, type: .error)
        }
    }
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
}

extension FeedViewModel: FilterFeedDelegate {
    func filterFeedPortfolios(_ filter: [String]) async {
        state.isRefreshing = true
        defer { state.isRefreshing.toggle() }
        
        state.filter = filter
        
        do {
            state.portfolios = try await readAllPortfoliosUseCase.execute(categories: state.filter, sortBy: state.sortBy)
        } catch {
            state.toastData = .init(message: L.Feed.portfolioLoadFailed, type: .error)
        }
    }
    
    func removeFilterCategory(_ category: String) async {
        state.filter.removeAll(where: { $0 == category })
        await filterFeedPortfolios(state.filter)
    }
}

public struct IImage: Identifiable, Equatable, Codable {
    public static func == (lhs: IImage, rhs: IImage) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id = UUID()
    public let src: MyImageEnum
    
    enum CodingKeys: String, CodingKey {
        case id, src
    }
    
    public init(src: MyImageEnum) {
        self.src = src
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // For server responses, we'll always get a string URL
        let urlString = try container.decode(String.self, forKey: .src)
        self.src = .remote(urlString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch src {
        case .remote(let url):
            try container.encode(url, forKey: .src)
        case .local:
            // When sending to server, we can't encode local images
            throw EncodingError.invalidValue(
                src,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Cannot encode local images to server"
                )
            )
        }
    }
}

public enum MyImageEnum {
    case remote(String)
    case local(UIImage)
}
