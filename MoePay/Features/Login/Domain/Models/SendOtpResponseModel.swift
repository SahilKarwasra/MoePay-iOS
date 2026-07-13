//
//  OtpResponseModel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

struct SendOtpResponseModel: Decodable, Sendable {
    let expiresIn: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case phoneNumber = "phone_number"
    }
}


struct OtpRequestModel: Encodable, Sendable {
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
    }
}
