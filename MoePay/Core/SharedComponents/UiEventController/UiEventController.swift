//
//  UiEventController.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

final class UiEventController: Sendable {
    
    static let shared = UiEventController()
    
    let events: AsyncStream<UiEvent>
    private let continuation: AsyncStream<UiEvent>.Continuation
    
    private init() {
        (events, continuation) = AsyncStream.makeStream(
            bufferingPolicy: .bufferingNewest(16)
        )
    }
    
    func send(_ event: UiEvent) {
        continuation.yield(event)
    }
    
}

extension UiEventController {
    func toast(_ message: String, isLong:Bool = false) {
        send(.Toast(message: message, isLong: isLong))
    }
}
