//
//  AuthCoordinator.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//


import SwiftUI

@Observable
final class AuthCoordinator {

    var path = NavigationPath()

    func push(_ route: AuthRoutes) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
