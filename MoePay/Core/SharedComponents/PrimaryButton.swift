//
//  PrimaryButton.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool
    var isEnabled: Bool
    
    var body: some View {
        Button {
            guard !isLoading else { return }
            action()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                isEnabled
                    ? Color.brandPrimary
                    : Color.brandPrimary.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .disabled(!isEnabled || isLoading)
    }
}
