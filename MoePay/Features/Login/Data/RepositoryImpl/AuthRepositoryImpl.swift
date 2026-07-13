//
//  AuthRepositoryImpl.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

final class AuthRepositoryImpl: AuthRepository {
    
    private let authApi : AuthApi
    init(authApi: AuthApi) {
        self.authApi = authApi
    }
    
    func generateOTP(phone: String) async -> APIResult<SendOtpResponseModel> {
        await authApi.generateOtp(.init(phoneNumber: phone))
    }
    
//    func verifyOTP(phone: String, otp: String) async -> ApiResult<SendOtpResponseModel> {
//        
//    }
    
    
}
