//
//  SecondaryButton.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 15/07/26.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isEnabled: Bool = true

    var body: some View {
        Button {
            guard !isLoading else { return }
            action()
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(isEnabled ? .brandPrimary : .gray)
                } else {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            isEnabled
                                ? Color.primary
                                : Color.primary.opacity(0.5)
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isEnabled
                            ? Color.primary
                            : Color.primary.opacity(0.5),
                        lineWidth: 1.5
                    )
            }
        }
        .disabled(!isEnabled || isLoading)
    }
}
