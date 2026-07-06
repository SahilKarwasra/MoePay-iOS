//
//  OnboardingModel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//
import Foundation

struct OnboardingModel: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageName: String
}
