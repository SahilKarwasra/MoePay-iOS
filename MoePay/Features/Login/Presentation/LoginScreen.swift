//
//  LoginScreen.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

struct LoginScreen: View {
    @State
    private var loginViewmodel = LoginViewmodel()
    @Environment(AuthCoordinator.self) private var authCoordinator

    var body: some View {
        VStack {
            VerticalSpacer(height: 16)
            Text("Phone number")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VerticalSpacer(height: 8)

            Text("Enter your phone number")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VerticalSpacer(height: 12)

            HStack(spacing: 8) {
                Text(loginViewmodel.state.countryCode)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(Color.surfaceBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.borderSubtle, lineWidth: 1)
                    }
                TextField(
                    "Phone Number",
                    text: Binding(
                        get: { loginViewmodel.state.phoneNumber },
                        set: {
                            loginViewmodel.onAction(action: .phoneChange($0))
                        }
                    )
                )
                .keyboardType(.numberPad)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.surfaceBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.borderSubtle, lineWidth: 1)
                }
            }

            VerticalSpacer(height: 24)
            
            PrimaryButton(
                title: "Continue",
                action: {
                    loginViewmodel.onAction(action: .onContinueTapped)
                },
                isLoading: false,
                isEnabled: true
            )

        }.padding(.horizontal, 16).frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        ).onAppear {
            loginViewmodel.onEvent = { event in
                switch event {
                case .navigationToVerifyOtp(let phone):
                    authCoordinator.push(.verifyOtp(phone: phone))
                }
            }
        }

    }
}

#Preview {
    LoginScreen()
}
