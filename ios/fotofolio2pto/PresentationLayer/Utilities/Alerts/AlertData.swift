//
//  AlertData.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//  Reused from https://github.com/MateeDevs/devstack-native-app/tree/develop
//

import Foundation

struct AlertData: Equatable, Identifiable {
    
    var id: String { title + (message ?? "") }
    
    let title: String
    let message: String?
    let primaryAction: AlertData.Action
    let secondaryAction: AlertData.Action?
    
    init(
        title: String,
        message: String? = nil,
        primaryAction: AlertData.Action = AlertData.Action(title: "Zavřít", style: .default),
        secondaryAction: AlertData.Action? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    static func == (lhs: AlertData, rhs: AlertData) -> Bool {
        lhs.title == rhs.title &&
        lhs.message == rhs.message &&
        lhs.primaryAction == rhs.primaryAction &&
        lhs.secondaryAction == rhs.secondaryAction
    }
}

extension AlertData {
    struct Action: Equatable {
        let title: String
        let style: Style
        let handler: (() -> Void)
        
        init(
            title: String,
            style: Style = .default,
            handler: @escaping (() -> Void) = {}
        ) {
            self.title = title
            self.style = style
            self.handler = handler
        }
        
        static func == (lhs: Action, rhs: Action) -> Bool {
            lhs.title == rhs.title &&
            lhs.style == rhs.style
        }
    }
}

extension AlertData.Action {
    enum Style {
        case `default`
        case cancel
        case destruction
    }
}
