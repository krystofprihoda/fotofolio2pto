//
//  SearchFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SearchFlowController: BaseFlowController {
    
    private let signedInUserId: String
    
    init(
        navigationController: UINavigationController,
        signedInUserId: String
    ) {
        self.signedInUserId = signedInUserId
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = SearchViewModel(flowController: self, signedInUserId: signedInUserId)
        let view = SearchView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    public func showProfile(of user: User) {
        let fc = ProfileFlowController(
            navigationController: navigationController,
            signedInUserId: signedInUserId,
            displayedUser: user.username,
            showDismiss: true
        )
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}
