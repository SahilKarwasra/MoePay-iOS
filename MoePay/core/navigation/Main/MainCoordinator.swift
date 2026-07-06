//
//  MainCoordinator.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

import SwiftUI

@Observable
final class MainCoordinator {

    var path = NavigationPath()

    func push(_ route: MainRoutes) {
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
