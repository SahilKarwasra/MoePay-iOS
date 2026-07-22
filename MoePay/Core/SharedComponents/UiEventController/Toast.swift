//
//  Toast.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

import SwiftUI

struct Toast: Equatable, Identifiable {

    enum Length: Equatable {
        case short, long

        var seconds: TimeInterval {
            switch self {
            case .short:
                2.0
            case .long: 3.5
            }
        }
    }

    let id: UUID = UUID()
    let message: String
    let length: Length
    var isError: Bool = false

    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.id == rhs.id &&
               lhs.message == rhs.message &&
               lhs.length == rhs.length &&
               lhs.isError == rhs.isError
    }
}

struct ToastView: View {
    let toast: Toast
    let onDismiss: () -> Void

    private var isError: Bool { toast.isError == true }
 
    var body: some View {
        if isError != true {
            standardToast
        } else {
            errorSnackbar
        }
    }

    private var standardToast: some View {
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
 
    private var errorSnackbar: some View {
        HStack(spacing: 12) {

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.yellow)

            Text(toast.message)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()

            if toast.isError {
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(width: 24, height: 24)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.00, green: 0.45, blue: 0.45),
                            Color(red: 1.00, green: 0.38, blue: 0.38)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 16, y: 8)
        .padding(.horizontal, 20)
    }
 
    private var backgroundColor: Color {
        Color(red: 0.82, green: 0.20, blue: 0.20)
    }
}
 

