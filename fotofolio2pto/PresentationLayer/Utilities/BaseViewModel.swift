//
//  BaseViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
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
    
    /// Override this method in a subclass for custom behavior when a view appears
    public func onAppear() {}
    
    /// Override this method in a subclass for custom behavior when a view disappears
    public func onDisappear() {
        // Cancel all tasks when we are going away
        tasks.forEach { $0.cancel() }
    }
    
    @discardableResult
    func executeTask(_ task: Task<Void, Never>) -> Task<Void, Never> {
        tasks.append(task)
        Task {
            await task.value
            
            // Remove task when done
            objc_sync_enter(tasks)
            tasks = tasks.filter { $0 != task }
            objc_sync_exit(tasks)
        }
        
        return task
    }
}
