//
//  LoginViewmodel.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 07/07/26.
//
import Foundation

struct OtpResponseModel : Codable, Equatable {
    let success: Bool
    let message: String
}

@Observable
final class LoginViewmodel {

    private(set) var state = LoginState()
    private var events: LoginEvent?

    func onAction(action: LoginAction) {
        switch action {
        case .onContinueTapped: onContinueTapped()
        case .countryChange(let country): state.countryCode = country
        case .phoneChange(let phone): state.phoneNumber = phone
        }
    }
    var responseMessage: String = ""
    func onContinueTapped() {
        let sendOtp = "http://127.0.0.1:8080/api/v1/auth/send-otp"
        guard let sendOtpUrl = URL(string: sendOtp) else { return }
        
        var request = URLRequest(url: sendOtpUrl)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "phone_number" : state.phoneNumber
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(OtpResponseModel.self, from: data)
                print("Message is : \(result.message)")
                print("Is Success : \(result.success)")
            } catch {
                
            }
        }.resume()
    }


}
