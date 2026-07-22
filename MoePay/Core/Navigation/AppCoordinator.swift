//
//  AppCordinator.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//
import SwiftUI

@Observable
final class AppCoordinator {
    var flow: AppFlow = .splash
    
    func showSplash() {
        flow = .splash
    }
    
    func showOnboarding() {
        flow = .onboarding
    }
    
    func showMain() {
        flow = .main
    }
}
