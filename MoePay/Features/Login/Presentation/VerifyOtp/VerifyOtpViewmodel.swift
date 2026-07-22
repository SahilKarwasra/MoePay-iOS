import Combine
//
//  VerifyOtpViewmodel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 15/07/26.
//
import Foundation

@Observable
final class VerifyOtpViewmodel {
    private var timer: AnyCancellable?
    private let resendCooldown = 30

    private(set) var state = VerifyOtpState()
    var onEvent: ((LoginEvent) -> Void)?

    private let repository: any AuthRepository

    let phoneNumber: String

    init(
        repository: any AuthRepository = AppDIContainer.shared.authRepository,
        phoneNumber: String
    ) {
        self.repository = repository
        self.phoneNumber = phoneNumber
    }

    func onAction(_ action: VerifyOtpAction) {
        switch action {
        case .otpChanged(let otp):
            state.otp = String(
                otp.filter(\.isNumber)
                    .prefix(state.otpLength)
            )

        case .verifyOtp:
            verifyOtp()

        case .resendOtp:
            resendOtp()

        case .startTimer:
            startTimer()
        }

    }

    private func verifyOtp() {
        Task {
            await repository.verifyOTP(phone: phoneNumber, otp: state.otp)
                .sendSnackbarOnError()
                .onSuccess { data in
                    UiEventController.shared.toast("Otp Verified Successfully")
                }
        }
    }

    private func resendOtp() {
        Task {
            await repository.generateOTP(phone: phoneNumber)
                .sendSnackbarOnError()
                .onSuccess { it in
                    UiEventController.shared.toast(
                        "Otp Send to \(it.phoneNumber)"
                    )
                    state.secondsRemaining = 30
                    startTimer()
                }
        }

    }

    private func startTimer() {

        timer?.cancel()

        state.secondsRemaining = resendCooldown

        timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in

            guard let self else { return }

            if state.secondsRemaining > 0 {
                state.secondsRemaining -= 1
            } else {
                timer?.cancel()
            }
        }
    }

    deinit {
        timer?.cancel()
    }
}
