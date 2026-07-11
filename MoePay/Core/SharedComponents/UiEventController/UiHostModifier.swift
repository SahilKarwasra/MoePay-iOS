//
//  UiHostModifier.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

import SwiftUI

struct UiHostModifier: ViewModifier {

    @State private var toast: Toast?
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let toast {
                    ToastView(toast: toast)
                        .padding(.bottom, 24)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                        .allowsHitTesting(false)
                }
            }
            .animation(.spring(duration: 0.3), value: toast)
            .task {
                for await event in UiEventController.shared.events {
                    handle(event)
                }
            }
    }

    private func handle(_ event: UiEvent) {
        switch event {
        case .Toast(let message, let isLong):
            show(Toast(message: message, length: isLong ? .long : .short))
        }
    }

    private func show(_ newToast: Toast) {
        dismissTask?.cancel()
        toast = newToast

        UIAccessibility.post(
            notification: .announcement,
            argument: newToast.message
        )

        dismissTask = Task {
            try? await Task.sleep(for: .seconds(newToast.length.seconds))
            guard !Task.isCancelled else { return }
            toast = nil
        }
    }
}

extension View {
    func toastHost() -> some View {
        modifier(UiHostModifier())
    }
}
