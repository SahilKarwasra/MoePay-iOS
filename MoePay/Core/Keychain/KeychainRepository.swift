//
//  KeychainRepository.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//
import Foundation
import Security

actor KeychainRepository {
    private let defaults = UserDefaults.standard
    
    func getToken() async -> String? {
        await MainActor.run { KeychainStore.read(.authToken) }
    }
    func saveToken(_ token: String) async {
        await MainActor.run { KeychainStore.save(token, .authToken) }
    }
    
    func getRefreshToken() async -> String? {
        await MainActor.run { KeychainStore.read(.refreshToken) }
    }
    func saveRefreshToken(_ token: String) async {
        await MainActor.run { KeychainStore.save(token, .refreshToken) }
    }
    
    func getPrivateKey() async -> String? {
        await MainActor.run { KeychainStore.read(.privateKey) }
    }
    func savePrivateKey(_ key: String) async {
        await MainActor.run { KeychainStore.save(key, .privateKey) }
    }
    func saveIsNewUser(_ isNew: Bool) {
        defaults.set(isNew, forKey: KeychainKeys.saveIsNewUser.rawValue)
    }
    
    func clearAll() async {
        await MainActor.run {
            KeychainStore.delete(.authToken)
            KeychainStore.delete(.refreshToken)
            KeychainStore.delete(.privateKey)
        }
    }
    
}
