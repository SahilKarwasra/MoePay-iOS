//
//  KeychainStore.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//
import Security
import Foundation

enum KeychainStore {
    enum Key: String {
        case authToken, refreshToken, privateKey
    }

    static func save(_ value: String, _ key: Key) {
        let base: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.laarasoft.moepay",
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(base as CFDictionary)
        var attrs = base
        attrs[kSecValueData as String] = Data(value.utf8)
        attrs[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(attrs as CFDictionary, nil)
    }

    static func read(_ key: Key) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.laarasoft.moepay",
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true
        ]
        var out: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &out)
        return (out as? Data).flatMap { String(data: $0, encoding: .utf8) }
    }

    static func delete(_ key: Key) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.laarasoft.moepay",
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
}

