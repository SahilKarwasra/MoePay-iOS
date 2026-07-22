//
//  LoginViewmodel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//
import Foundation

@Observable
final class LoginViewmodel {

    private(set) var state = LoginState()
    var onEvent: ((LoginEvent) -> Void)?
    private let repository: any AuthRepository

    init(repository: any AuthRepository = AppDIContainer.shared.authRepository)
    {
        self.repository = repository
    }

    func onAction(action: LoginAction) {
        switch action {
        case .onContinueTapped: onContinueTapped()
        case .countryChange(let country): state.countryCode = country
        case .phoneChange(let phone): state.phoneNumber = phone
        }
    }
    func onContinueTapped() {
        Task {
            await repository.generateOTP(phone: state.phoneNumber)
                .sendSnackbarOnError()
                .onSuccess { it in
                    UiEventController.shared.toast(
                        "Otp Send to \(it.phoneNumber)"
                    )
                    Task { @MainActor in
                        onEvent?(.navigationToVerifyOtp(phone: state.phoneNumber))
                    }
                }
        }
    }

}
