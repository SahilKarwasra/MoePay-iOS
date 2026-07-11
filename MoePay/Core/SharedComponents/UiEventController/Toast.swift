//
//  Toast.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

import SwiftUI

struct Toast: Equatable, Identifiable {
    enum length {
        case short, long
        
        var seconds: TimeInterval {
            switch self {
            case .short:
                2.0
            case .long: 3.5
            }
        }
    }
    
    let id = UUID()
    let message: String
    let length: length
}

struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        Text(toast.message)
            .font(.subheadline.weight(.medium))
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.85))
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            )
            .padding(.horizontal, 32)
            .accessibilityAddTraits(.isStaticText)
    }
}
