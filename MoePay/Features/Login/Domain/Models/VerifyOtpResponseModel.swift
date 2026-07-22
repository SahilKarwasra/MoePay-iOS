//
//  VerifyOtpResponseModel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 15/07/26.
//

struct VerifyOtpResponseModel: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
    let isUserNew: Bool

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case isUserNew = "is_user_new"
    }
}

struct VerifyOtpRequestModel: Encodable, Sendable {
    let otp: String
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case otp = "otp"
    }
}
