//
//  FeedFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import UIKit

public protocol FeedFlowControllerDelegate: AnyObject {
    func filterFeedPortfolios(_ filter: [String]) async
    func removeFilterTag(_ tag: String) async
}

class FeedFlowController: BaseFlowController {

    private let signedInUser: String
    private var backgroundFilterTapView: UIView?
    
    weak var feedFlowDelegate: FeedFlowControllerDelegate?
    
    init(
        navigationController: UINavigationController,
        signedInUser: String
    ) {
        self.signedInUser = signedInUser
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = FeedViewModel(flowController: self, signedInUser: signedInUser)
        feedFlowDelegate = vm
        let view = FeedView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }

    public func presentFilter(with filter: [String]) {
        let vm = FilterViewModel(flowController: self, with: filter)
        let vc = BaseHostingController(rootView: FilterView(viewModel: vm))
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        
        addBackgroundTapView()
        navigationController.present(vc, animated: true)
    }
    
    func dismissFilter() {
        removeBackgroundTapView()
        navigationController.dismiss(animated: true)
    }
    
    func showProfile(user: User) {
        let fc = ProfileFlowController(navigationController: navigationController, signedInUser: signedInUser, displayedUser: user.username)
        let vc = startChildFlow(fc)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
}

/// Hack for recognizing taps outside the bottom sheet
extension FeedFlowController: UISheetPresentationControllerDelegate {
    // Implement the delegate methods to handle dismissal
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true // Allow dismissal
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Additional actions after dismissal if needed
        removeBackgroundTapView()
    }
    
    private func addBackgroundTapView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let tapView = UIView(frame: window.bounds)
        tapView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapView.addGestureRecognizer(tapGesture)
        
        window.addSubview(tapView)
        backgroundFilterTapView = tapView
    }

    private func removeBackgroundTapView() {
        backgroundFilterTapView?.removeFromSuperview()
        backgroundFilterTapView = nil
    }

    @objc private func handleBackgroundTap() {
        dismissFilter()
    }
}
