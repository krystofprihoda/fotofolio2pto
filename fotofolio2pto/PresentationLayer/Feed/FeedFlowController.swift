//
//  FeedFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import UIKit

class FeedFlowController: BaseFlowController {

    private var backgroundTapView: UIView?

    override func setup() -> UIViewController {
        let vm = FeedViewModel(flowController: self)
        let view = FeedView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }

    public func presentFilter() {
        let vm = FilterViewModel(flowController: self)
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
        navigationController.dismiss(animated: true)
    }
}

/// Hack for recognizing taps outside the bottom sheet
extension FeedFlowController {
    private func addBackgroundTapView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let tapView = UIView(frame: window.bounds)
        tapView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFilterBackgroundTap))
        tapView.addGestureRecognizer(tapGesture)
        
        window.addSubview(tapView)
        backgroundTapView = tapView
    }

    @objc private func handleFilterBackgroundTap() {
        dismissFilter()
        
        backgroundTapView?.removeFromSuperview()
        backgroundTapView = nil
    }
}
