//
//  Endpoint.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//
import Foundation

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct Endpoint: Sendable {
    var path: String
    var method: HTTPMethod = .get
    var query: [String: String?] = [:]
    var headers: [String: String] = [:]
    var body: RequestBody? = nil
    var requiresAuth: Bool = true
    var decoding: DecodingStrategy = .envelop

    enum DecodingStrategy {
        case envelop
        case raw
    }

    enum RequestBody: Sendable {
        case raw(Data, contentType: String)
        case multipart([MultipartField])

        static func json(_ value: some Encodable, encoder: JSONEncoder = .api)
            -> RequestBody
        {
            do {
                return .raw(
                    try encoder.encode(value),
                    contentType: "application/json"
                )
            } catch {
                assertionFailure(
                    "Failed to encode \(Swift.type(of: value)): \(error)"
                )
                return .raw(Data(), contentType: "application/json")
            }
        }
    }
}

extension JSONEncoder {
    static var api: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }
}

extension JSONDecoder {
    static var api: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}

struct MultipartField: Sendable {
    let name: String
    let content: Content

    enum Content: Sendable {
        case text(String)
        case file(data: Data, filename: String, mimeType: String)
    }

    static func text(_ name: String, _ value: String) -> MultipartField {
        MultipartField(name: name, content: .text(value))
    }

    static func file(
        _ name: String,
        data: Data,
        filename: String,
        mimeType: String = "image/jpeg"
    ) -> MultipartField {
        MultipartField(name: name, content: .file(data: data, filename: filename, mimeType: mimeType))
    }
}
