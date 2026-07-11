//
//  UiEvent.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

enum UiEvent: Sendable {
    case Toast(message: String, isLong: Bool = false)
}
