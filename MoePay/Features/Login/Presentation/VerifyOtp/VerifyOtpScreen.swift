//
//  VerifyOtp.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import Combine
import SwiftUI

struct VerifyOtpScreen: View {

    @State private var viewModel: VerifyOtpViewmodel

    init(phoneNumber: String) {
        _viewModel = State(
            initialValue: VerifyOtpViewmodel(
                phoneNumber: phoneNumber
            )
        )
        self.phoneNumber = phoneNumber
    }
    @FocusState private var isFieldFocused: Bool

    let phoneNumber: String

    var body: some View {
        VStack {
            VerticalSpacer(height: 16)

            Text("Verify Phone number")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VerticalSpacer(height: 8)

            Text(
                "Check your SMS inbox and enter the 6-digit code we just send on \(phoneNumber) "
            )
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)

            VerticalSpacer(height: 24)

            otpBoxes

            VerticalSpacer(height: 24)

            PrimaryButton(
                title: "Verify OTP",
                action: {
                    viewModel.onAction(.verifyOtp)
                },
                isLoading: viewModel.state.isLoading,
                isEnabled: viewModel.state.isLoading == false
                    && viewModel.state.otp.count == 6
            )

            VerticalSpacer(height: 16)

            resendRow

        }.padding(.horizontal, 16).frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        ).onAppear {
            viewModel.onAction(.startTimer)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                isFieldFocused = true
            }
        }
    }

    private var otpBoxes: some View {
        ZStack {
            TextField(
                "",
                text: Binding(
                    get: {
                        viewModel.state.otp
                    },
                    set: {
                        viewModel.onAction(.otpChanged($0))
                    }
                )
            )
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($isFieldFocused)
            .frame(width: 1, height: 1)
            .opacity(0.01)

            HStack(spacing: 12) {
                ForEach(0..<viewModel.state.otpLength, id: \.self) { index in
                    otpBox(at: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFieldFocused = true
            }
        }
    }

    private func otpBox(at index: Int) -> some View {
        let digits = Array(viewModel.state.otp)
        let char = index < digits.count ? String(digits[index]) : ""
        let isActive =
            isFieldFocused
            && index
                == min(viewModel.state.otp.count, viewModel.state.otpLength - 1)

        return RoundedRectangle(cornerRadius: 14)
            .fill(Color(.secondarySystemBackground))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isActive ? Color.primary : Color.secondary,
                        lineWidth: 1.5
                    )
            )
            .overlay(
                Text(char)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.primary)
            )
            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)
            .animation(.easeInOut(duration: 0.15), value: isActive)
    }

    @ViewBuilder
    private var resendRow: some View {

        if viewModel.state.canResend {
            SecondaryButton(
                title: "Resend OTP",
                action: {
                    viewModel.onAction(.resendOtp)
                }
            )
        } else {
            HStack(spacing: 4) {
                Text("Resend OTP in")
                    .font(.system(size: 16, weight: .semibold))
                Text(viewModel.state.formattedTime)
                    .font(.system(size: 16, weight: .heavy))
                    .monospacedDigit()
            }
        }
    }

}

#Preview {
    VerifyOtpScreen(phoneNumber: "9812408030")
}
