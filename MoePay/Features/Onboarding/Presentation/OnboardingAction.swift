//
//  OnboardingAction.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

enum OnboardingAction {
    case pageChange(Int)
    case nextTap
    case skipTap
}

enum OnboardingEvent : Equatable {
    case navigateToLogin
}
