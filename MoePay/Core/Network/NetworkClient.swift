//
//  NetworkClient.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//
import Foundation

final class NetworkClient: Sendable {
    private let tokenProvider: any TokenProvider
    private let baseURL: URL
    private let session: URLSession
    private let excludedLogPaths: Set<String>

    init(
        tokenProvider: any TokenProvider,
        baseURL: URL,
        session: URLSession,
        excludedLogPaths: Set<String> = []
    ) {
        self.tokenProvider = tokenProvider.self
        self.baseURL = baseURL
        self.session = session
        self.excludedLogPaths = excludedLogPaths
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async -> APIResult<T> {
        do {
            var urlRequest = try makeURLRequest(for: endpoint)
            if endpoint.requiresAuth {
                await applyAuthHeaders(to: &urlRequest)
            }

            var (data, response) = try await execute(
                urlRequest,
                path: endpoint.path
            )

            // 401 on an authenticated call → single-flight token refresh, retry once.
            // This is the ConnectionInterceptor 401 branch, minus the locking.
            if endpoint.requiresAuth,
                (response as? HTTPURLResponse)?.statusCode == 401
            {
                //                 if await refreshCoordinator.refresh() {
                //                     await applyAuthHeaders(to: &urlRequest)
                //                     (data, response) = try await execute(urlRequest, path: endpoint.path)
                //                 } else {
                //                     await tokenProvider.onSessionExpired()
                //                     // Fall through: the 401 below maps to .unauthorized, and
                //                     // sendSnackbarOnError turns that into UIEvent.sessionExpired.
                //                 }
            }

            guard let http = response as? HTTPURLResponse else {
                return .failure(.remote(.unknown, message: "Non-HTTP response"))
            }
            return mapResponse(
                data: data,
                statusCode: http.statusCode,
                decoding: endpoint.decoding
            )
        } catch let error as DataError {
            return .failure(error)
        } catch {
            return .failure(Self.transportError(error))
        }
    }
    /// whose payload you don't care about.
    func requestEmpty(_ endpoint: Endpoint) async -> EmptyAPIResult {
        await request(endpoint)
    }

    private func execute(_ request: URLRequest, path: String) async throws -> (
        Data, URLResponse
    ) {
        do {
            logRequest(request, path: path, attempt: 0)
            let (data, response) = try await session.data(for: request)
            logResponse(response, data: data, path: path)
            return (data, response)
        } catch is CancellationError {
            throw CancellationError()
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw CancellationError()
        } catch {
            throw error
        }
    }

    private func makeURLRequest(for endpoint: Endpoint) throws -> URLRequest {
        let url = baseURL.appending(path: endpoint.path)

        guard
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
        else {
            throw DataError.remote(
                .unknown,
                message: "Invalid URL for path \(endpoint.path)"
            )
        }
        let queryItems = endpoint.query.compactMap { key, value in
            value.map { URLQueryItem(name: key, value: $0) }
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let finalURL = components.url else {
            throw DataError.remote(
                .unknown,
                message: "Invalid URL for path \(endpoint.path)"
            )
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = endpoint.body {
            switch body {
            case .raw(let data, let contentType):
                request.setValue(
                    contentType,
                    forHTTPHeaderField: "Content-Type"
                )
                request.httpBody = data
            case .multipart(let fields):
                let form = MultipartFormData()
                request.setValue(
                    form.contentTypeHeader,
                    forHTTPHeaderField: "Content-Type"
                )
                request.httpBody = form.encode(fields)
            }
        }
        return request
    }

    private func mapResponse<T: Decodable>(
        data: Data,
        statusCode: Int,
        decoding: Endpoint.DecodingStrategy
    ) -> APIResult<T> {
        switch statusCode {
        case 200...299:
            return decodeSuccess(data: data, decoding: decoding)
        case 400:
            return .failure(
                .remote(
                    .badRequest,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                )
            )
        case 401:
            return .failure(
                .remote(
                    .unauthorized,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                )
            )
        case 404:
            return .failure(
                .remote(
                    .notFound,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                )
            )
        case 408:
            return .failure(.remote(.requestTimeout))
        case 409:
            return .failure(
                .remote(
                    .conflict,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                        ?? "Conflict"
                )
            )
        case 413:
            return .failure(.remote(.payloadTooLarge))
        case 429:
            return .failure(.remote(.tooManyRequest))
        case 500...599:
            return .failure(
                .remote(
                    .serverError,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                )
            )
        default:
            return .failure(
                .remote(
                    .unknown,
                    message: ErrorMessageExtractor.readableMessage(from: data)
                        ?? "Unexpected error with no readable message"
                )
            )
        }
    }

    private func decodeSuccess<T: Decodable>(
        data: Data,
        decoding: Endpoint.DecodingStrategy
    ) -> APIResult<T> {
        let decoder = JSONDecoder.api

        switch decoding {
        case .raw:
            // isNotByData = true → decode the body directly, no envelope.
            do {
                return .success(try decoder.decode(T.self, from: data))
            } catch {
                return .failure(
                    .remote(.serialization, message: error.localizedDescription)
                )
            }

        case .envelop:
            do {
                let envelope = try decoder.decode(
                    BaseResponse<T>.self,
                    from: data
                )

                guard envelope.success,
                    [200, 201].contains(envelope.statusCode)
                else {
                    return .failure(
                        .remote(.unknown, message: envelope.message)
                    )
                }
                if let payload = envelope.data {
                    return .success(payload, message: envelope.message)
                }
                // Kotlin: T::class == Unit::class
                if T.self == Empty.self, let empty = Empty() as? T {
                    return .success(empty, message: envelope.message)
                }
                return .failure(
                    .remote(
                        .serialization,
                        message: "Expected data but got null"
                    )
                )
            } catch {
                return .failure(
                    .remote(.serialization, message: error.localizedDescription)
                )
            }
        }
    }
    private func applyAuthHeaders(to request: inout URLRequest) async {
        let token = await tokenProvider.accsssToken() ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    private static func transportError(_ error: Error) -> DataError {
        if error is CancellationError {
            // Callers can ignore this; sendSnackbarOnError stays silent for it.
            return .remote(.cancellation)
        }
        guard let urlError = error as? URLError else {
            return .remote(.unknown, message: error.localizedDescription)
        }
        switch urlError.code {
        case .timedOut:
            return .remote(
                .requestTimeout,
                message: urlError.localizedDescription
            )
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed,
            .internationalRoamingOff, .cannotFindHost, .cannotConnectToHost,
            .dnsLookupFailed:
            return .remote(.noInternet, message: urlError.localizedDescription)
        default:
            return .remote(.unknown, message: urlError.localizedDescription)
        }
    }

    // MARK: - Debug logging (the Ktor Logging plugin port)
    //
    private func logRequest(_ request: URLRequest, path: String, attempt: Int) {
        #if DEBUG
            guard !excludedLogPaths.contains(path) else { return }
            let retry = attempt > 0 ? " (retry \(attempt))" : ""
            print(
                "➡️ [\(request.httpMethod ?? "?")] \(request.url?.absoluteString ?? path)\(retry)"
            )
            // Headers
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                print("Headers:")
                headers.forEach { key, value in
                    print("  \(key): \(value)")
                }
            }

            // Body
            if let body = request.httpBody, !body.isEmpty {
                if let json = String(data: body, encoding: .utf8) {
                    print("Body:")
                    print(json)
                } else {
                    print("Body: <\(body.count) bytes of binary data>")
                }
            }

        #endif
    }

    private func logResponse(_ response: URLResponse, data: Data, path: String)
    {
        #if DEBUG
            guard !excludedLogPaths.contains(path) else { return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            let body =
                String(data: data.prefix(2_000), encoding: .utf8)
                ?? "<binary \(data.count) bytes>"
            print("⬅️ [\(status)] \(path)\n\(body)")
        #endif
    }

}

final class NetworkClientFactory: Sendable {

    private let session: URLSession
    private let tokenProvider: any TokenProvider
    private let baseURLProvider: any BaseURLProvider

    init(
        tokenProvider: any TokenProvider,
        baseURLProvider: any BaseURLProvider = DefaultBaseURLProvider()
    ) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 180
        configuration.waitsForConnectivity = false
        configuration.urlCache = URLCache(
            memoryCapacity: 5 * 1024 * 1024,
            diskCapacity: 20 * 1024 * 1024
        )
        self.session = URLSession(configuration: configuration)
        self.tokenProvider = tokenProvider
        self.baseURLProvider = baseURLProvider
    }

    func client(excludedLogPaths: Set<String> = []) -> NetworkClient {
        NetworkClient(
            tokenProvider: tokenProvider,
            baseURL: baseURLProvider.baseURL,
            session: session,
            excludedLogPaths: excludedLogPaths
        )
    }
}
