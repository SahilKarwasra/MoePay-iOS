//
//  AuthRepositoryImpl.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

final class AuthRepositoryImpl: AuthRepository {
        
    private let authApi : AuthApi
    private let storage: KeychainRepository
    init(authApi: AuthApi, storage: KeychainRepository) {
        self.authApi = authApi
        self.storage = storage
    }
    
    func generateOTP(phone: String) async -> APIResult<SendOtpResponseModel> {
        await authApi.generateOtp(.init(phoneNumber: phone))
    }
    
    func verifyOTP(phone: String, otp: String) async -> APIResult<VerifyOtpResponseModel> {
        await authApi.verifyOtp(VerifyOtpRequestModel(otp: otp, phoneNumber: phone)).onSuccess { VerifyOtpResponseModel in
            Task {
                await storage.saveToken(VerifyOtpResponseModel.accessToken)
                await storage.saveRefreshToken(VerifyOtpResponseModel.refreshToken)
                await storage.saveIsNewUser(VerifyOtpResponseModel.isUserNew)
            }
        }
    }
}
