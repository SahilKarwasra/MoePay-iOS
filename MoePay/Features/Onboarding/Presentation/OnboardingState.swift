//
//  OnboardingState.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

struct OnboardingState {
    var steps: [OnboardingModel] = [
        OnboardingModel(
            title: "Power up your Payments with EWallet",
            description:
                "Send, receive and manage money effortlessly with our secure E-wallet. Tap Scan and go!",
            imageName: "onboarding_1"
        ),
        OnboardingModel(
            title: "Pay Bills in Seconds \n Anytime, Anywhere",
            description:
                "Track and pay all your utility bills in one app. \n  No more waiting in line or going to the bank.",
            imageName: "onboarding_2"
        ),
        OnboardingModel(
            title: "Send & Receive Money Worldwide. \n No Fees. No Charges",
            description:
                "Fast and secure transfers at your fingertips. \n Anytime, anywhere.",
            imageName: "onboarding_3"
        ),
    ]
    var currentStep: Int = 0
    var isLastStep: Bool { currentStep == steps.count - 1 }
}

