//
//  BaseViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//  Reused from https://github.com/MateeDevs/devstack-native-app/tree/develop
//

import Foundation
import OSLog

@MainActor
public class BaseViewModel {
    
    let trackScreenAppear: () -> Void
    
    /// All tasks that are currently executed
    private var tasks: [Task<Void, Never>] = []
    
    init(trackScreenAppear: @escaping () -> Void = {}) {
        self.trackScreenAppear = trackScreenAppear
        Logger.lifecycle.info("👶 | \(type(of: self)) initialized 👀🛩️")
    }
    
    deinit {
        Logger.lifecycle.info("💀 | \(type(of: self)) deinitialized 👀🛩️")
    }
    
    /// Override for custom appear behavior
    public func onAppear() {}
    
    /// Override for custom disappear behavior
    public func onDisappear() {
        /// Cancel all tasks on exit
        tasks.forEach { $0.cancel() }
    }
    
    @discardableResult
    func executeTask(_ task: Task<Void, Never>) -> Task<Void, Never> {
        tasks.append(task)
        Task {
            await task.value
            
            objc_sync_enter(tasks)
            tasks = tasks.filter { $0 != task }
            objc_sync_exit(tasks)
        }
        
        return task
    }
}
