//
//  VerifyOtpAction.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 15/07/26.
//

enum VerifyOtpAction {
    case otpChanged(String)
    case verifyOtp
    case resendOtp
    case startTimer
}

enum VerifyOtpEvent: Equatable {
    case navigateToNext
}
