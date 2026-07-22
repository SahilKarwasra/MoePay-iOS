//
//  VerifyOtpState.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 15/07/26.
//

import Foundation

struct VerifyOtpState {
    let otpLength = 6
    var isLoading: Bool = false
    var otp: String = ""
    var secondsRemaining: Int = 30
    var canResend: Bool {
        secondsRemaining == 0
    }

    var canVerifyOtp: Bool {
        otp.count == 6 && !isLoading
    }

    var formattedTime: String {
        String(
            format: "%d:%02d",
            secondsRemaining / 60,
            secondsRemaining % 60
        )
    }
}
