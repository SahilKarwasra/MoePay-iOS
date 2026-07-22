//
//  OnboardingViewmodel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import Foundation

@Observable
final class OnboardingViewModel {
    private(set) var state = OnboardingState()

    func onAction(actions: OnboardingAction) {
        switch actions {
        case .pageChange(let int):
            state.currentStep = int
        case .nextTap:
            state.currentStep += 1
        case .skipTap:
            state.currentStep = state.steps.count - 1
        }
    }
}
