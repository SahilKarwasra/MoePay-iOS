//
//  MultipartFormData.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

import Foundation

struct MultipartFormData {

    let boundary = "laara.boundary.\(UUID().uuidString)"

    var contentTypeHeader: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    func encode(_ fields: [MultipartField]) -> Data {
        var body = Data()
        for field in fields {
            body.appendString("--\(boundary)\r\n")
            switch field.content {
            case .text(let value):
                body.appendString("Content-Disposition: form-data; name=\"\(field.name)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            case let .file(data, filename, mimeType):
                body.appendString(
                    "Content-Disposition: form-data; name=\"\(field.name)\"; filename=\"\(filename)\"\r\n"
                )
                body.appendString("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        append(Data(string.utf8))
    }
}
