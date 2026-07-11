//
//  LoginState.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//

struct LoginState {
    var phoneNumber: String = ""
    var countryCode: String = "+91"
    var isContinueEnabled: Bool {
        phoneNumber.count >= 10
    }
    var isLoading: Bool = false
}

