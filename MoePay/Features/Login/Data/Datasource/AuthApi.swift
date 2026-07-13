//
//  AuthApi.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

final class AuthApi {
    private let client: NetworkClient
    init(client: NetworkClient) {
        self.client = client
    }
    
    func generateOtp(_ request: SendOtpRequestModel) async -> APIResult<SendOtpResponseModel> {
        await client.request(Endpoint(
            path: "auth/send-otp",
            method: .post,
            body: .json(request),
            requiresAuth: false
        ))
    }
}
