//
//  AuthFlow.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

import SwiftUI

struct AuthFlow: View {
    @State private var coordinator = AuthCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            OnboardingScreen()
                .navigationDestination(for: AuthRoutes.self) { route in
                    switch route {
                        case .onboarding: OnboardingScreen()
                        case .login: LoginScreen()
                        case .verifyOtp(let phone): VerifyOtpScreen(
                            phoneNumber: phone
                        )
                    }
                }
        }.environment(coordinator)
    }
}
