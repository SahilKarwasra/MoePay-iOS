//
//  AuthRepository.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

protocol AuthRepository: Sendable {
    func generateOTP(phone: String) async -> APIResult<SendOtpResponseModel>
//    func verifyOTP(phone: String, otp: String) async -> ApiResult<SendOtpResponseModel>
}
