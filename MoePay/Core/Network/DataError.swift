//
//  DataError.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//

enum DataError: Error, Equatable, Sendable {
    case remote(RemoteType, message: String?)
    case local(LocalType, message: String?)

    static func remote(_ type: RemoteType) -> DataError {
        .remote(type, message: nil)
    }
    static func local(_ type: LocalType) -> DataError {
        .local(type, message: nil)
    }

    enum RemoteType: Equatable, Sendable {
        case requestTimeout
        case unauthorized
        case conflict
        case fileNotFound
        case tooManyRequest
        case noInternet
        case payloadTooLarge
        case serverError
        case serialization
        case unknown
        case cancellation
        case permissionDenied
        case locationUnavailable
        case notFound
        case badRequest
    
    }

    enum LocalType: Equatable, Sendable {
        case diskFull
        case unknown
        case dataNotFound
        case database
    }

    var message: String? {
        switch self {
        case .remote(_, let message), .local(_, let message):
            return message
        }
    }
    
    var remoteType: RemoteType? {
        if case let .remote(type, _) = self { return type }
        return nil
    }
    
    var localType: LocalType? {
        if case let .local(type, _) = self { return type }
        return nil
    }
}
