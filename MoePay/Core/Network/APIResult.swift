//
//  ApiResult.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 11/07/26.
//
import Foundation

enum APIResult<T> {
    case success(T, message: String?)
    case failure(DataError)
}

extension APIResult: Sendable where T: Sendable {}

// for if the data is {}
typealias EmptyAPIResult = APIResult<Empty>

struct Empty: Decodable, Equatable, Sendable {
    init() {}
}

extension APIResult {
    static func success(_ data: T) -> APIResult<T> {
        .success(data, message: nil)
    }

    var value: T? {
        if case .success(let data, _) = self {
            return data
        }
        return nil
    }

    var error: DataError? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }

    var successMessgae: String? {
        if case .success(_, let message) = self {
            return message
        }
        return nil
    }

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    func map<R>(_ transform: (T) -> R) -> APIResult<R> {
        switch self {
        case .success(let data, let message):
            return .success(transform(data), message: message)
        case .failure(let error): return .failure(error)
        }
    }

    func flatmap<R>(_ transform: (T) -> APIResult<R>) -> APIResult<R> {
        switch self {
        case .success(let data, _): return transform(data)
        case .failure(let error): return .failure(error)
        }
    }

    func asEmptyResult() -> EmptyAPIResult {
        map { _ in
            Empty()
        }
    }

    @discardableResult
    func onSuccess(_ action: (T) -> Void) -> APIResult<T> {
        if case .success(let data, _) = self {
            action(data)
        }
        return self
    }

    @discardableResult
    func onError(_ action: (DataError) -> Void) -> APIResult<T> {
        if case .failure(let error) = self {
            action(error)
        }
        return self
    }
}
