//
//  SplashScreen.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    var body: some View {
        Text("Splash Screen!")
            .task {
                try? await Task.sleep(for: .seconds(2))
                appCoordinator.showOnboarding()
            }
    }
}

#Preview {
    SplashScreen()
}
