//
//  SearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation

final class SearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    // UCs
    
    private weak var flowController: SearchFlowController?
    
    // MARK: Init
    
    init(
        flowController: SearchFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: State
    
    struct State {
        var isLoading: Bool = false
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case doSomething(sth: Int)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .doSomething(let sth): doSomething(sth)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func doSomething(_ sth: Int) {
        
    }
}
