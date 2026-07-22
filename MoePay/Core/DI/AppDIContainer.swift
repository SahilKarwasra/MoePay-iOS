//
//  AppDIContainer.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

final class AppDIContainer: Sendable {
    static let shared = AppDIContainer()
    
    let storage: KeychainRepository
    let tokenProvider: any TokenProvider
    let client: NetworkClientFactory
    let authApi: AuthApi
    let authRepository: any AuthRepository
    
    private init() {
        let storage = KeychainRepository()
        self.storage = storage
        
        let tokenProvider = TokenProviderImpl(storage: storage)
        self.tokenProvider = tokenProvider
        
        let client = NetworkClientFactory(tokenProvider: tokenProvider)
        self.client = client
        
        let authApi = AuthApi(client: client.client())
        self.authApi = authApi
        
        self.authRepository = AuthRepositoryImpl(authApi: authApi, storage: storage)
    }
}
