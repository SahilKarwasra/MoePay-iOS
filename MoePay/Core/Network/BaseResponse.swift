//
//  BaseResponse.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let data: T?
    let message: String?
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
        case message
        case success
    }
}

enum ErrorMessageExtractor {

    static func readableMessage(from data: Data) -> String? {
        guard !data.isEmpty else { return nil }

        if let envelope = try? JSONDecoder().decode(MessageEnvelope.self, from: data),
           let message = envelope.message?.trimmed, !message.isEmpty {
            return message
        }

        if let root = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
            let keys = ["message", "error", "remarks", "description", "responseMessage"]
            let containers = [root, root["data"] as? [String: Any]].compactMap { $0 }
            for container in containers {
                for key in keys {
                    if let value = container[key] as? String, !value.trimmed.isEmpty {
                        return value
                    }
                }
            }
        }

        let raw = String(decoding: data, as: UTF8.self).trimmed
        return raw.isEmpty ? nil : String(raw.prefix(300))
    }

    private struct MessageEnvelope: Decodable {
        let message: String?
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
