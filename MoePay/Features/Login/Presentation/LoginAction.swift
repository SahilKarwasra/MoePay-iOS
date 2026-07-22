//
//  LoginAction.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

enum LoginAction {
    case countryChange(String)
    case phoneChange(String)
    case onContinueTapped
}

enum LoginEvent: Equatable {
    case navigationToVerifyOtp(phone: String)
}
