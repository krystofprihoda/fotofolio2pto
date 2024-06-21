//
//  ViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation

@MainActor
protocol ViewModel {
    /// Lifecycle
    func onAppear()
    func onDisappear()
    
    /// State
    associatedtype State
    var state: State { get }
    
    /// Intent
    associatedtype Intent
    @discardableResult func onIntent(_ intent: Intent) -> Task<Void, Never>
}

/// Template ViewModel

//final class TemplateViewModel: BaseViewModel, ViewModel, ObservableObject {
//    // MARK: Stored properties
//    
//    // MARK: Dependencies
//    
//    // UCs
//    
//    private weak var flowController: FeedFlowController?
//    
//    // MARK: Init
//    
//    init(
//        flowController: TemplateFlowController?
//    ) {
//        self.flowController = flowController
//        super.init()
//    }
//    
//    // MARK: Lifecycle
//    
//    override func onAppear() {
//        super.onAppear()
//    }
//    
//    // MARK: State
//    
//    struct State {
//        var isLoading: Bool = false
//    }
//    
//    @Published private(set) var state = State()
//    
//    // MARK: Intent
//    
//    enum Intent {
//        case doSomething(sth: Int)
//    }
//    
//    @discardableResult
//    func onIntent(_ intent: Intent) -> Task<Void, Never> {
//        executeTask(Task {
//            switch intent {
//            case .doSomething(let sth): doSomething(sth)
//            }
//        })
//    }
//    
//    // MARK: Additional methods
//    
//    private func doSomething(_ sth: Int) {
//        
//    }
//}
