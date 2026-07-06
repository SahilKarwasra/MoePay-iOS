//
//  MainFlow.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

import SwiftUI

struct MainFlow: View {
    @State private var coordinator = MainCoordinator()
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeScreen()
                .navigationDestination(for: MainRoutes.self) { routes in
                    switch routes {
                    case .home: HomeScreen()
                    case .chat: ChatScreen()
                    case .ewallet: EwalletScreen()
                    }
                }
        }.environment(coordinator)
    }
}

#Preview {
    MainFlow()
}
