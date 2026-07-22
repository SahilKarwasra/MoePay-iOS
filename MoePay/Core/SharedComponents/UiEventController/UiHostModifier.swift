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

    private var alignment: Alignment {
        toast?.isError == true ? .top : .bottom
    }

    private var edge: Edge {
        toast?.isError == true ? .top : .bottom
    }

    private var padding: (Edge.Set, CGFloat) {
        toast?.isError == true
            ? (.top, 12)
            : (.bottom, 24)
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                if let toast {
                    ToastView(toast: toast, onDismiss: dismissToast)
                        .padding(padding.0, padding.1)
                        .transition(
                            .move(edge: edge).combined(with: .opacity)
                        )
                        .id(toast.id)
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
        case .Toast(let message, let isLong, let isError):
            show(
                Toast(
                    message: message,
                    length: isLong ? .long : .short,
                    isError: isError
                )
            )
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
            try? await Task.sleep(
                for: .seconds(newToast.length.seconds)
            )
            guard !Task.isCancelled else { return }
            await MainActor.run {
                toast = nil
            }
        }
    }

    private func dismissToast() {
        dismissTask?.cancel()
        withAnimation { toast = nil }
    }
}

extension View {
    func toastHost() -> some View {
        modifier(UiHostModifier())
    }
}
