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
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(.white))
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Color.brandPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

#Preview {
    PrimaryButton(title: "done", action: {})
}
