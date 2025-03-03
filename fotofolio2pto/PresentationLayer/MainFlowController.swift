//
//  MainFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

public enum MainTab: Int {
    case feed = 0
    case selection = 1
    case search = 2
    case messages = 3
    case profile = 4
}

public protocol MainFlowControllerDelegate: AnyObject {
    func signOut()
}

public class MainFlowController: BaseFlowController {
    
    private let user: String
    weak var flowDelegate: MainFlowControllerDelegate?
    
    init(
        navigationController: UINavigationController,
        flowDelegate: MainFlowControllerDelegate? = nil,
        user: String
    ) {
        self.user = user
        self.flowDelegate = flowDelegate
        super.init(navigationController: navigationController)
    }
    
    public override func setup() -> UIViewController {
        setupMainTabBarController()
    }
    
    private func setupMainTabBarController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        var navViewControllers: [UINavigationController] = []
        
        // MARK: Feed
        
        let feedNavController = getFeedNavigationController()
        navViewControllers.append(feedNavController)
        
        // MARK: Selection
        
        let selectionNavController = getSelectionNavigationController()
        navViewControllers.append(selectionNavController)
        
        // MARK: Search
        
        let searchNavController = getSearchNavigationController()
        navViewControllers.append(searchNavController)
        
        // MARK: Messages
        
        let messagesNavController = getMessagesNavigationController()
        navViewControllers.append(messagesNavController)
        
        // MARK: Profile
        
        let profileNavController = getProfileNavigationController()
        navViewControllers.append(profileNavController)
        
        tabBarVC.setViewControllers(navViewControllers, animated: true)
        
        return tabBarVC
    }
    
    private func getFeedNavigationController() -> UINavigationController {
        let feedNavController = UINavigationController()
        feedNavController.tabBarItem = UITabBarItem(
            title: L.Feed.title,
            image: UIImage(systemName: "square.text.square"),
            tag: MainTab.feed.rawValue
        )
        let feedFlowController = FeedFlowController(navigationController: feedNavController, signedInUser: user)
        let feedRootVC = startChildFlow(feedFlowController)
        feedNavController.viewControllers = [feedRootVC]
        
        return feedNavController
    }
    
    private func getSelectionNavigationController() -> UINavigationController {
        let selectionNavController = UINavigationController()
        selectionNavController.tabBarItem = UITabBarItem(
            title: L.Selection.title,
            image: UIImage(systemName: "star.square"),
            tag: MainTab.selection.rawValue
        )
        let selectionFlowController = SelectionFlowController(navigationController: selectionNavController, signedInUser: user)
        let selectionRootVC = startChildFlow(selectionFlowController)
        selectionNavController.viewControllers = [selectionRootVC]
        
        return selectionNavController
    }
    
    private func getSearchNavigationController() -> UINavigationController {
        let searchNavController = UINavigationController()
        searchNavController.tabBarItem = UITabBarItem(
            title: L.Search.title,
            image: UIImage(systemName: "magnifyingglass"),
            tag: MainTab.search.rawValue
        )
        let searchFlowController = SearchFlowController(navigationController: searchNavController, signedInUser: user)
        let searchRootVC = startChildFlow(searchFlowController)
        searchNavController.viewControllers = [searchRootVC]
        
        return searchNavController
    }
    
    private func getMessagesNavigationController() -> UINavigationController {
        let messagesNavController = UINavigationController()
        messagesNavController.tabBarItem = UITabBarItem(
            title: L.Messages.title,
            image: UIImage(systemName: "message"),
            tag: MainTab.messages.rawValue
        )
        let messagesFlowController = MessagesFlowController(navigationController: messagesNavController, sender: user)
        let messagesRootVC = startChildFlow(messagesFlowController)
        messagesNavController.viewControllers = [messagesRootVC]
        
        return messagesNavController
    }
    
    private func getProfileNavigationController() -> UINavigationController {
        let profileNavController = UINavigationController()
        profileNavController.tabBarItem = UITabBarItem(
            title: L.Profile.title,
            image: UIImage(systemName: "person.crop.square"),
            tag: MainTab.profile.rawValue
        )
        let profileFlowController = ProfileFlowController(
            navigationController: profileNavController,
            flowDelegate: self,
            signedInUser: user,
            displayedUser: user
        )
        let profileRootVC = startChildFlow(profileFlowController)
        profileNavController.viewControllers = [profileRootVC]
        
        return profileNavController
    }
    
    func switchToFeed() {
        switchTab(.feed)
    }
    
    func switchToSelection() {
        switchTab(.selection)
    }
    
    @discardableResult private func switchTab(_ type: MainTab) -> BaseFlowController? {
        willSwitchTab()
        
        guard let main = rootViewController as? UITabBarController else { return nil }
        
        if let index = getViewControllerTabIndex(for: type) {
            main.selectedIndex = index
        }
        
        let flowControllerIndex = getFlowControllerTabIndex(for: type) ?? 0
        return childControllers[flowControllerIndex]
    }
    
    private func getViewControllerTabIndex(for type: MainTab) -> Int? {
        guard let main = rootViewController as? UITabBarController else { return nil }
        return main.viewControllers?.firstIndex { viewController in
            switch type {
            case .feed:
                return viewController.tabBarItem.tag == MainTab.feed.rawValue
            case .selection:
                return viewController.tabBarItem.tag == MainTab.selection.rawValue
            case .search:
                return viewController.tabBarItem.tag == MainTab.search.rawValue
            case .messages:
                return viewController.tabBarItem.tag == MainTab.messages.rawValue
            case .profile:
                return viewController.tabBarItem.tag == MainTab.profile.rawValue
            }
        }
    }
    
    private func getFlowControllerTabIndex(for type: MainTab) -> Int? {
        childControllers.firstIndex { flowController in
            switch type {
            case .feed:
                return flowController is FeedFlowController
            case .selection:
                return flowController is SelectionFlowController
            case .search:
                return flowController is SearchFlowController
            case .messages:
                return flowController is MessagesFlowController
            case .profile:
                return flowController is ProfileFlowController
            }
        }
    }
    
    func willSwitchTab() {
        guard let main = rootViewController as? UITabBarController,
              main.selectedIndex < childControllers.count,
              let selectedNavController = main.selectedViewController as? UINavigationController
        else { return }
        
        // Dismiss presented controllers
        selectedNavController.dismiss(animated: false, completion: nil)
        
        // Pop to root in current tab
        selectedNavController.popToRootViewController(animated: false)
        
        // FlowController of current tab
        let tabFc = childControllers[main.selectedIndex]
        
        // Stop all child flows
        for child in tabFc.childControllers {
            child.stopFlow()
        }
    }
    
    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }
}

extension MainFlowController: ProfileFlowControllerDelegate {
    public func signOut() {
        flowDelegate?.signOut()
        stopFlow()
    }
}
