//
//  TokenProvider.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

struct TokenPair: Sendable {
    let accessToken: String
    let refreshToken: String
}

protocol TokenProvider: Sendable {
    func accsssToken() async -> String?
    func refreshToken() async -> String?
}

actor TokenProviderImpl: TokenProvider {
    
    
    private let storage: KeychainRepository
    private var refreshExecutor: (@Sendable (String) async -> TokenPair?)?
    
    init(storage: KeychainRepository) {
        self.storage = storage
    }
    
    func accsssToken() async -> String? {
        await storage.getToken()
    }
    
    func refreshToken() async -> String? {
        await storage.getRefreshToken()
    }
    
    
    func store(_ tokens: TokenPair) async {
        await storage.saveToken(tokens.accessToken)
        await storage.saveRefreshToken(tokens.refreshToken)
    }
        
    func onSessionExpired() async {
        await storage.clearAll()
    }
}
