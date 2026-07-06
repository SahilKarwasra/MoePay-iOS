//
//  MoePayApp.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

@main
struct MoePayApp: App {
    @State private var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            switch coordinator.flow {
            case .splash:
                SplashFlow()
            case .onboarding:
                AuthFlow()
            case .main:
                MainFlow()
            }
        }.environment(coordinator)
    }
}

