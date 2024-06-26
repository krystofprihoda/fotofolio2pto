//
//  SearchFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SearchFlowController: BaseFlowController {
    
    private let signedInUser: String
    
    init(
        navigationController: UINavigationController,
        signedInUser: String
    ) {
        self.signedInUser = signedInUser
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = SearchViewModel(flowController: self)
        let view = SearchView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    public func showProfile(of user: User) {
        let fc = ProfileFlowController(navigationController: navigationController, signedInUser: signedInUser, displayedUser: user.username)
        let vc = startChildFlow(fc)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
}
